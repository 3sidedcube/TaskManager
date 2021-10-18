//
//  Task+Extension.swift
//  TaskManagerTests
//
//  Created by Ben Shutt on 06/10/2021.
//  Copyright © 2021 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

extension Task {

    /// Execute and call `completion` on the main thread
    ///
    /// - Parameters:
    ///   - completion: Completion closure
    func executeOnMain(
        completion: @escaping (TaskResult) -> Void
    ) {
        execute { result in
            DispatchQueue.executeOnMain {
                completion(result)
            }
        }
    }
}
