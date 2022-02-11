//
//  Throttle.swift
//  TaskManager
//
//  Created by Ben Shutt on 11/02/2022.
//  Copyright © 2021 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

/// Store and execute the most recent `DispatchWorkItem` in a specified time interval.
public struct Throttle {

    /// Functionality which executes
    public typealias Task = () -> Void

    /// Last `DispatchWorkItem` to be executed
    private var lastWorkItem: DispatchWorkItem?

    /// Execute `task` after `delay` on `queue`
    ///
    /// - Parameters:
    ///   - delay: `TimeInterval`
    ///   - queue: `DispatchQueue`
    ///   - task: `Task`
    public mutating func execute(
        after delay: TimeInterval,
        on queue: DispatchQueue = .main,
        task: @escaping Task
    ) {
        // Cancel previous work if required
        lastWorkItem?.cancel()

        // Create a new work item
        let work = DispatchWorkItem(block: task)
        lastWorkItem = work

        // Execute on queue after delay
        let deadline: DispatchTime = .now() + max(0, delay)
        queue.asyncAfter(deadline: deadline, execute: work)
    }
}
