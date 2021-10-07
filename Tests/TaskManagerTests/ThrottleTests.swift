//
//  ThrottleTests.swift
//  TaskManager
//
//  Created by Ben Shutt on 06/10/2021.
//  Copyright © 2021 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import XCTest
@testable import TaskManager

/// Test the throttling of `TaskManager`
final class ThrottleTests: XCTestCase {

    /// Test the throttle of `TaskManager`
    func testThrottle() {
        let expectation = XCTestExpectation()

        // Setup time intervals
        let throttle: TimeInterval = 1
        let taskLength: TimeInterval = 1
        let total = throttle + taskLength

        // Setup dateTimeStamps
        let startDate = Date()
        var endDate = Date() // Initialize in case of timeout

        // Create TaskManager and execute Task
        let taskManager = TestTaskManager()
        taskManager.onTaskComplete = { _, _ in
            endDate = Date()
            expectation.fulfill()
        }
        taskManager.execute(TestTask(wait: taskLength), throttle: throttle)

        // Wait for expectation
        wait(for: [expectation], timeout: total + 1)

        // Check expected result
        let diff = endDate.timeIntervalSince(startDate)
        XCTAssertTrue(diff >= total)
    }

    /// TODO: WIP
    /// Test the throttle of `TaskManager`
    func testInvalidation() {
        let expectation = XCTestExpectation()
        let finalTaskUUID = UUID()

        // Create TaskManager and execute Task
        let taskManager = TestTaskManager()
        taskManager.onTaskComplete = { task, _ in
            XCTAssertEqual(task.uuid, finalTaskUUID)
        }
        taskManager.execute(TestTask(wait: 1), throttle: 2)

        // Should interrupt throttle
        runAfter(1) {
            taskManager.execute(TestTask(wait: 1), throttle: 1.1)
        }

        // Should interrupt throttle again
        runAfter(1) {
            taskManager.execute(TestTask(wait: 2), throttle: 1)
        }

        // Should interrupt task
        runAfter(2) {
            taskManager.execute(TestTask(wait: 2), throttle: 1)
        }

        // Should task again
        runAfter(2) {
            taskManager.execute(TestTask(wait: 2), throttle: 1)
        }

        taskManager.execute(TestTask(wait: 2), throttle: 2)

        wait(for: [expectation], timeout: 100)
    }

    private func runAfter(
        _ timeInterval: TimeInterval,
        on queue: DispatchQueue = .main,
        execute: @escaping () -> Void
    ) {
        let expectation = expectation(description: "\(#function)")

        queue.asyncAfter(deadline: .now() + timeInterval) {
            execute()
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: timeInterval + 1)
    }
}
