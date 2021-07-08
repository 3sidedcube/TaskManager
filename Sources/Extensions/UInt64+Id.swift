//
//  UInt64+Id.swift
//  Task
//
//  Created by Ben Shutt on 08/07/2021.
//  Copyright © 2021 3 SIDED CUBE APP PRODUCTIONS LTD. All rights reserved.
//

import Foundation

public extension UInt64 {

    /// Increment by 1, unless the value is `max` then reset back to `initial`
    /// 
    /// - Parameter initial: `UInt64` to reset to when `max`
    func incrementing(initial: UInt64 = 0) -> UInt64 {
        guard self < UInt64.max else { return initial }
        return self + 1
    }

    /// `UInt64` of first task
    internal static var firstTaskId: UInt64 {
        return 1
    }
}
