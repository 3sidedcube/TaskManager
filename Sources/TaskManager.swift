//
//  TaskManager.swift
//  Task
//
//  Created by Ben Shutt on 08/07/2021.
//  Copyright © 2021 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

/// Throttle and execute a `Task`
open class TaskManager<TaskType> where TaskType: Task {

    /// Task state
    public enum State {

        /// No tasks started or invalidated
        case notStarted

        /// Invalidated task
        case invalidated(TaskType?)

        /// A task is running
        case running(TaskType)

        /// A task completed with result
        case complete(TaskType, TaskType.TaskResult)
    }

    /// `Timer` to throttle tasks
    private var throttleTimer: Timer?

    /// Currently running task
    ///
    /// - Note:
    /// A task is still considered to be "running" if it is in a throttled state (will execute after a delay)
    private var currentTask: IdentifiedTask<TaskType>?

    /// Latest `State`
    open private(set) var state: State = .notStarted

    // MARK: - Init

    /// Invalidate
    deinit {
        invalidate()
    }

    // MARK: - Task

    /// Is there a search task in progress
    public var isRunning: Bool {
        return runningTask != nil
    }

    /// Running `TaskType`
    public var runningTask: TaskType? {
        return currentTask?.task
    }

    /// Execute `task` after `throttle`
    ///
    /// - Parameters:
    ///   - task: `TaskType` to execute
    ///   - throttle: `TimeInterval` throttle, `nil` to execute immediately
    open func execute(
        _ task: TaskType,
        throttle: TimeInterval? = .defaultThrottle
    ) {
        // Invalidate previous search
        invalidate()

        // Set the current task
        currentTask = IdentifiedTask(taskId: nextTaskId(), task: task)
        state = .running(task)

        // Check for throttling
        guard let throttle = throttle else {
            // Do not throttle, search immediately
            performSearch()
            return
        }

        // Start throttle
        throttleTimer = Timer.scheduledTimer(
            withTimeInterval: max(0, throttle),
            repeats: false
        ) { [weak self] timer in
            guard timer.isValid else { return }
            self?.performSearch()
        }
    }

    /// Get the next task ID
    private func nextTaskId() -> UInt64 {
        let nextTaskId = currentTask?.taskId.incrementing(initial: .firstTaskId)
        return nextTaskId ?? .firstTaskId
    }

    /// Actually execute the `currentTask`
    ///
    /// If there was a throttle, this is called after the throttle has finished.
    private func performSearch() {
        // Check if there is still a task
        guard let identifiedTask = currentTask else { return }

        // Task to execute
        let task = identifiedTask.task

        // Execute the task
        task.execute { [weak self] result in
            // Check still in memory
            guard let self = self else { return }

            // Check the task is still valid
            guard self.isValid(identifiedTask) else { return }

            // Complete task
            self.task(task, didCompleteWith: result)
        }
    }

    /// Check `identifiedTask` is (still) valid
    ///
    /// - Parameter identifiedTask: `IdentifiedTask<TaskType>`
    private func isValid(
        _ identifiedTask: IdentifiedTask<TaskType>
    ) -> Bool {
        return identifiedTask == currentTask
    }

    /// `task` did complete with `result`
    ///
    /// - Parameters:
    ///   - task: `TaskType`
    ///   - result: `TaskType.TaskResult`
    private func task(
        _ task: TaskType,
        didCompleteWith result: TaskType.TaskResult
    ) {
        // Invalidate completed task
        invalidate()

        // Complete
        state = .complete(task, result)
    }

    // MARK: - Invalidate

    /// Invalidate search task
    open func invalidate() {
        // Remove current search
        let previousTask = currentTask
        currentTask = nil

        // Invalidate timer
        throttleTimer?.invalidate()
        throttleTimer = nil

        // Update state
        state = .invalidated(previousTask?.task)
    }
}
