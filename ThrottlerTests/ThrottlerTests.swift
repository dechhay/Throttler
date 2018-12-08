//
//  ThrottlerTests.swift
//  ThrottlerTests
//
//  Created by Dennis Chhay on 11/26/18.
//  Copyright © 2018 Dennis Chhay. All rights reserved.
//

import XCTest
@testable import Throttler

class ThrottlerTests: XCTestCase {
    
    var throttler: Throttler?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        throttler = nil
        super.tearDown()
    }
    
    func testFire() {
        let delay: TimeInterval = 1.5
        let dispatchQueue = DispatchQueue.main
        let expectation = XCTestExpectation(description: "\(#function)")
        throttler = Throttler(delay: delay, dispatchQueue: dispatchQueue) {
            expectation.fulfill()
        }
        throttler?.fire()
        
        let timeout: TimeInterval = 1.0
        wait(for: [expectation], timeout: timeout)
    }
    
    func testThrottle() {
        let delay: TimeInterval = 0.5
        let dispatchQueue = DispatchQueue.main
        let expectation = XCTestExpectation(description: "\(#function)")
        throttler = Throttler(delay: delay, dispatchQueue: dispatchQueue) {
            expectation.fulfill()
        }
        throttler?.throttle()
        
        let timeout: TimeInterval = 1.0
        wait(for: [expectation], timeout: timeout)
    }
    
    
    func testThrottleTime() {
        let delay: TimeInterval = 2.0
        let dispatchQueue = DispatchQueue.main
        let expectation = XCTestExpectation(description: "\(#function)")
        let startTime = Date()
        throttler = Throttler(delay: delay, dispatchQueue: dispatchQueue) {
            let timeElapsed = Date().timeIntervalSince(startTime)
            let expectedTimeElapsed = delay
            let percentDiff = abs(expectedTimeElapsed - timeElapsed) / expectedTimeElapsed
            let tolerance: TimeInterval = 0.10
            if percentDiff < tolerance  {
                expectation.fulfill()
            }
        }
        throttler?.throttle()

        let padding: TimeInterval =  4.0
        let timeout: TimeInterval = delay + padding
        wait(for: [expectation], timeout: timeout)
    }
    
    func testThrottleInterrupt() {
        let delay: TimeInterval = 2.0
        let secondThrottleWait = delay * 0.90
        let dispatchQueue = DispatchQueue.main
        let expectation = XCTestExpectation(description: "\(#function)")
        let startTime = Date()
        throttler = Throttler(delay: delay, dispatchQueue: dispatchQueue) {
            let timeElapsed = Date().timeIntervalSince(startTime)
            let expectedTimeElapsed = secondThrottleWait + delay
            let percentDiff = abs(expectedTimeElapsed - timeElapsed) / expectedTimeElapsed
            let tolerance: TimeInterval = 0.10
            if percentDiff < tolerance  {
                expectation.fulfill()
            }
        }
        throttler?.throttle()
        
        // Second throttle
        let deadline = DispatchTime.now() + secondThrottleWait
        dispatchQueue.asyncAfter(deadline: deadline) { [weak self] in
            self?.throttler?.throttle()
        }
        
        let padding: TimeInterval =  4.0
        let timeout: TimeInterval = secondThrottleWait + delay + padding
        wait(for: [expectation], timeout: timeout)
    }
    
}
