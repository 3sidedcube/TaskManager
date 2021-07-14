//
//  ManagedTask.swift
//  TaskManager
//
//  Created by Ben Shutt on 08/07/2021.
//  Copyright © 2021 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

/// A `Task` with a `UInt64` Id
public struct IdentifiedTask<Task> {

    /// `UInt64` identifier of the task
    public let taskId: UInt64

    /// The `Task`
    public let task: Task
}

// MARK: - Equatable

extension IdentifiedTask: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.taskId == rhs.taskId
    }
}
