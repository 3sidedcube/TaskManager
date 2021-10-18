//
//  TaskManager.swift
//  TaskManager
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

        /// A task is being throttled
        case throttling(TaskType)

        /// A task is executing
        case executing(TaskType)

        /// A task completed with result
        case complete(TaskType, TaskType.TaskResult)
    }

    /// `Timer` to throttle tasks
    private var throttleTimer: Timer?

    /// Currently running task
    private var currentTask: IdentifiedTask<TaskType>?

    /// Latest `State`
    public private(set) var state: State = .notStarted {
        didSet {
            didSetState(state)
        }
    }

    /// Called when the `state` is set
    open var onDidSetState: ((State) -> Void)?

    /// Called when `TaskType` competed
    open var onTaskComplete: ((TaskType, TaskType.TaskResult) -> Void)?

    // MARK: - Init

    /// Default initializer
    public init() {
    }

    /// Invalidate
    deinit {
        invalidate()
    }

    // MARK: - Task

    /// Is there a task running
    ///
    /// - Note:
    /// A task is still considered to be "running" if it is in a throttled or executing state
    public var isRunning: Bool {
        return runningTask != nil
    }

    /// Running `TaskType`
    public var runningTask: TaskType? {
        return currentTask?.task
    }

    /// Execute `task` after `throttle`.
    ///
    /// The current task will be cancelled.
    ///
    /// - Parameters:
    ///   - task: `TaskType` to execute
    ///   - throttle: `TimeInterval` throttle, `nil` to execute immediately
    open func execute(
        _ task: TaskType,
        throttle: TimeInterval? = .defaultThrottle
    ) {
        // Invalidate previous task
        invalidate(updateState: false)

        // Set the current task
        currentTask = IdentifiedTask(task: task)
        state = .throttling(task)

        // Check for throttling
        guard let throttle = throttle else {
            // Do not throttle, perform immediately
            performTask()
            return
        }

        // Start throttle
        throttleTimer = Timer.scheduledTimer(
            withTimeInterval: max(0, throttle),
            repeats: false
        ) { [weak self] timer in
            guard timer.isValid else { return }
            // Throttle did complete
            self?.performTask()
        }
    }

    /// Actually execute the `currentTask`
    ///
    /// If there was a throttle, this is called after the throttle has finished.
    private func performTask() {
        // Check if there is still a task
        guard let identifiedTask = currentTask else { return }

        // Task to execute
        let task = identifiedTask.task

        // Update state
        state = .executing(task)

        // Execute the task
        task.executeOnMain { [weak self] result in
            // Check still in memory
            guard let self = self else { return }

            // Check the task is still valid
            guard identifiedTask == self.currentTask else { return }

            // Invalidate completed task
            self.invalidate(updateState: false)

            // Complete
            self.state = .complete(task, result)

            // Call completion handler
            self.onTaskComplete?(task, result)
        }
    }

    /// On `self.state` was set to `state`
    ///
    /// - Parameter state: `State`
    open func didSetState(_ state: State) {
        onDidSetState?(state)
        // Subclasses can override
    }

    // MARK: - Invalidate

    /// Invalidate running task
    open func invalidate() {
        invalidate(updateState: true)
    }

    /// Invalidate running task
    ///
    /// - Parameter updateState: `Bool` update `state`
    private func invalidate(updateState: Bool) {
        // Remove current task
        let previousTask = currentTask?.task
        currentTask = nil

        // Invalidate timer
        throttleTimer?.invalidate()
        throttleTimer = nil

        // Update state
        if updateState {
            state = .invalidated(previousTask)
        }
    }
}
