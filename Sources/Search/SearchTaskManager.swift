//
//  SearchTaskManager.swift
//  Task
//
//  Created by Ben Shutt on 08/07/2021.
//  Copyright © 2021 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

/// A `TaskManager` which executes `SearchTask`s
class SearchTaskManager<Task>: TaskManager<Task> where Task: SearchTask {

    /// Search the given `search` after `throttle`
    ///
    /// - Parameters:
    ///   - search: `String` text to search
    ///   - throttle: `TimeInterval` throttle, `nil` to execute immediately
    func search(
        _ search: String,
        throttle: TimeInterval? = .defaultThrottle
    ) {
        let task = createTask(for: search)
        super.execute(task, throttle: throttle)
    }

    /// Create a `Task` for `search`
    ///
    /// - Parameter search: `String`
    func createTask(for search: String) -> Task {
        fatalError("\(#function) is abstract, subclasses must implement")
    }
}
