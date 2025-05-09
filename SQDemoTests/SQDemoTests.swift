//
//  SQDemoTests.swift
//  SQDemoTests
//
//  Created by Ben Patterson on 2/4/25.
//

import XCTest
@testable import OurSQDemo

// Mock Countable for Testing
final class MockCountable: Countable {
    var count = 0
    var incrementCalled = false
    var decrementCalled = false
    var resetCalled = false
    var burstCalled = false

    func increment() {
        incrementCalled = true
        count += 1
    }
    
    func decrement() {
        decrementCalled = true
        count = max(0, count - 1)
    }
    
    func reset() {
        resetCalled = true
        count = 0
    }
    
    func burst() {
        burstCalled = true
        count += 10
    }
}

// Test Suite
final class CounterViewModelTests: XCTestCase {

    var mockCounter: MockCountable!

    override func setUp() {
        super.setUp()
        mockCounter = MockCountable()
    }

    override func tearDown() {
        mockCounter = nil
        super.tearDown()
    }

    func test_InitialCount_IsZero() {
        XCTAssertEqual(mockCounter.count, 0, "Initial count should be zero.")
    }

    func test_Increment_IncreasesCount() {
        mockCounter.increment()
        XCTAssertTrue(mockCounter.incrementCalled, "Increment should be called.")
        XCTAssertEqual(mockCounter.count, 1, "Count should be incremented to 1.")
    }

    func test_Decrement_DecreasesCount() {
        mockCounter.count = 2
        mockCounter.decrement()
        XCTAssertTrue(mockCounter.decrementCalled, "Decrement should be called.")
        XCTAssertEqual(mockCounter.count, 1, "Count should decrement to 1.")
    }

    func test_Decrement_DoesNotGoBelowZero() {
        mockCounter.count = 0
        mockCounter.decrement()
        XCTAssertEqual(mockCounter.count, 0, "Count should not go below zero.")
    }

    func test_Reset_SetsCountToZero() {
        mockCounter.count = 5
        mockCounter.reset()
        XCTAssertTrue(mockCounter.resetCalled, "Reset should be called.")
        XCTAssertEqual(mockCounter.count, 0, "Count should reset to zero.")
    }
    
    func test_BURST_IncreasesCountByTen() {
        mockCounter.burst()
        XCTAssertTrue(mockCounter.burstCalled, "Burst should be called.")
        XCTAssertEqual(mockCounter.count, 10, "Count should be increased by 10.")
    }
}
