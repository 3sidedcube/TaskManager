//
//  ManagedTask.swift
//  TaskManager
//
//  Created by Ben Shutt on 08/07/2021.
//  Copyright © 2021 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

/// A `Task` with a `UUID` ID
public struct IdentifiedTask<Task> {

    /// `UUID` identifier of the task
    public let taskId: UUID

    /// `Task`
    public let task: Task

    /// Default memberwise initializer
    /// - Parameters:
    ///   - taskId: `UUID`
    ///   - task: `Task`
    public init(taskId: UUID = UUID(), task: Task) {
        self.taskId = taskId
        self.task = task
    }
}

// MARK: - Equatable

extension IdentifiedTask: Equatable {

    /// - Returns: Whether the `taskId` is the same for `lhs` and `rhs`
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.taskId == rhs.taskId
    }
}
