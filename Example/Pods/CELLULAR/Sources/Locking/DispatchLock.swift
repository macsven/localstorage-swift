/************************************************************************
 CELLULAR Proprietary
 Copyright (c) 2015, CELLULAR GmbH. All Rights Reserved

 CELLULAR GmbH., Große Elbstraße 39, D-22767 Hamburg, GERMANY

 All data and information contained in or disclosed by this document are
 confidential and proprietary information of CELLULAR, and all rights
 therein are expressly reserved. By accepting this material, the
 recipient agrees that this material and the information contained
 therein are held in confidence and in trust. The material may only be
 used and/or disclosed as authorized in a license agreement controlling
 such use and disclosure.
 *************************************************************************/

import Foundation

/// Readers writer lock ->
/// Allows multiple simultanous reading operations
// but only single writing operation
public final class DispatchLock: Lock {

    /// Queue to use for locking mechanism
    public let dispatchQueue: DispatchQueue

    /// Creates labeled DispatchLock.
    ///
    /// - Parameters:
    ///   - queue: Queue to dispatch reading or writing operations on.
    public init(queue: DispatchQueue) {
        self.dispatchQueue = queue
    }

    /// Synchrounously dispatches reading operation to queue
    ///
    /// - Parameter closure: Closure to lock
    /// - Returns: Whatever the closure returns
    /// - Throws: Whatever the closure throws
    public func read<T>(_ closure: () throws -> T) rethrows -> T {

        return try dispatchQueue.sync {
            return try closure()
        }
    }

    /// Synchrounously dispatches writing operation to queue
    ///
    /// - Parameter closure: Closure to lock
    /// - Returns: Whatever the closure returns
    /// - Throws: Whatever the closure throws
    @discardableResult
    public func write<T>(_ closure: () throws -> T) rethrows -> T {

        return try dispatchQueue.sync(flags: .barrier) {
            return try closure()
        }
    }
}