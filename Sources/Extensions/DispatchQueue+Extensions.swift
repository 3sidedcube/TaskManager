//
//  Task+Extension.swift
//  TaskManagerTests
//
//  Created by Ben Shutt on 18/10/2021.
//  Copyright © 2021 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

extension DispatchQueue {

    /// Execute `closure` on the main thread.
    /// - If the current thread is already main, execute immediately
    /// - Otherwise dispatch onto the back of the main `DispatchQueue`
    ///
    /// - Parameter closure: Closure to execute
    static func executeOnMain(closure: @escaping () -> Void) {
        if Thread.current.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
}
