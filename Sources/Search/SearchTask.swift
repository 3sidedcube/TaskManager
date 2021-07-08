//
//  SearchTask.swift
//  Task
//
//  Created by Ben Shutt on 08/07/2021.
//  Copyright © 2021 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

/// A task which executes given a `String` to search
public protocol SearchTask: Task {

    /// `String` text to search
    ///
    /// - Note:
    /// Once set, should not be mutated
    var search: String { get }
}
