//
//  Throttler.swift
//  Throttler
//
//  Created by Dennis Chhay on 11/26/18.
//  Copyright © 2018 Dennis Chhay. All rights reserved.
//

import Foundation

@objc
public class Throttler: NSObject {
    
    public var delay: TimeInterval = 0.5
    private var dispatchQueue: DispatchQueue = DispatchQueue.main
    private var dispatchBlock: (() -> Void) = {}
    private var dispatchWork: DispatchWorkItem?
    
    public convenience init(delay: TimeInterval = 0.5,
                     dispatchQueue: DispatchQueue = DispatchQueue.main,
                     dispatchBlock: @escaping () -> ()) {
        self.init()
        self.delay = delay
        self.dispatchQueue = dispatchQueue
        self.dispatchBlock = dispatchBlock
    }
    
}

// API
extension Throttler {
    
    /**
     Schedules the dispatch to run asynchronously after the delay time.
     */
    public func throttle() {
        if let work = dispatchWork {
            work.cancel()
        }
        let work = DispatchWorkItem(block: dispatchBlock)
        dispatchWork = work
        let deadline = DispatchTime.now() + delay
        dispatchQueue.asyncAfter(deadline: deadline, execute: work)
    }
    
    /**
     Triggers dispatch asynchronously.
     */
    public func fire() {
        if let work = dispatchWork,
           !work.isCancelled {
               work.perform()
               work.cancel()
               dispatchWork = nil
        } else {
            let work = DispatchWorkItem(block: dispatchBlock)
            dispatchWork = work
            let deadline = DispatchTime.now()
            dispatchQueue.asyncAfter(deadline: deadline, execute: work)
        }
    }
    
    /**
     Cancels any scheduled dispatch.
     */
    public func cancel() {
        guard let work = dispatchWork else {
            return
        }
        work.cancel()
        dispatchWork = nil
    }
    
}
