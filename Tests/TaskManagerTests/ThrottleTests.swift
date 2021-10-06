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
}
