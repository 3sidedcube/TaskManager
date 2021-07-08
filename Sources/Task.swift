//
//  Task.swift
//  Task
//
//  Created by Ben Shutt on 08/07/2021.
//  Copyright © 2021 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

/// A task which executes
public protocol Task {
    associatedtype TaskResult

    /// Execute the task calling `completion` when finished
    ///
    /// - Parameters:
    ///   - completion: Completion closure
    func execute(completion: @escaping (TaskResult) -> Void)
}
