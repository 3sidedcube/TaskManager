//
//  TestTask.swift
//  TaskManager
//
//  Created by Ben Shutt on 06/10/2021.
//  Copyright © 2021 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation
@testable import TaskManager

/// A test `Task` which waits a given `TimeInterval` (seconds) and completes
/// with the current `Date`
struct TestTask: Task {
    typealias TaskResult = Date

    /// `TimeInterval` to wait before completing with the current `Date`
    let wait: TimeInterval

    /// `DispatchQueue` to call completion handler on
    let completionQueue: DispatchQueue

    // MARK: - Init

    /// Initialize the given `TimeInterval` to wait
    ///
    /// - Parameters:
    ///   - waitSeconds: `TimeInterval`
    ///   - completionQueue: `DispatchQueue`
    init(
        wait: TimeInterval = 0,
        completionQueue: DispatchQueue = .main
    ) {
        self.wait = wait
        self.completionQueue = completionQueue
    }

    // MARK: - Task

    func execute(completion: @escaping (Date) -> Void) {
        let delay: DispatchTime = .now() + wait
        completionQueue.asyncAfter(deadline: delay) {
            completion(Date())
        }
    }
}
