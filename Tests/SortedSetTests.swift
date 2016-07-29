//
//  SortedSetTests.swift
//  SortedSetTests
//
//  Created by Bradley Hilton on 5/10/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

import XCTest
@testable import SortedSet

class SortedSetTests: XCTestCase {
    
    func testInsertion() {
        func test(initial: SortedSet<Int>, insert element: Int, assert expected: SortedSet<Int>) {
            var array = initial
            array.insert(element)
            XCTAssert(array == expected)
        }
        test([], insert: -1, assert: [-1])
        test([0], insert: -1, assert: [-1, 0])
        test([0], insert: 1, assert: [0, 1])
        test([0, 1], insert: 2, assert: [0, 1, 2])
        test([0, 1], insert: -1, assert: [-1, 0, 1])
        test([0, 2], insert: 3, assert: [0, 2, 3])
        test([0, 2], insert: -1, assert: [-1, 0, 2])
        test([0, 2], insert: 1, assert: [0, 1, 2])
        test([-1, 0, 3], insert: 1, assert: [-1, 0, 1, 3])
        test([2, 3, 5, 9], insert: 8, assert: [2, 3, 5, 8, 9])
        test([-3, -1, 2, 8, 11], insert: -2, assert: [-3, -2, -1, 2, 8, 11])
        test([-5, -4, -1, 0, 1, 3, 4, 5, 8, 9, 11, 12, 13], insert: 2, assert: [-5, -4, -1, 0, 1, 2, 3, 4, 5, 8, 9, 11, 12, 13])
    }
    
    func testRemove() {
        func test(initial: SortedSet<Int>, remove element: Int, assert expected: SortedSet<Int>) {
            var array = initial
            array.remove(element)
            XCTAssert(array == expected)
        }
        test([], remove: 1, assert: [])
        test([0], remove: 0, assert: [])
        test([0], remove: 1, assert: [0])
        test([0, 1], remove: 0, assert: [1])
        test([0, 2, 5, 7], remove: 5, assert: [0, 2, 7])
    }
    
    func testInsertionAndRemove() {
        var set: SortedSet<UInt32> = []
        for _ in 0..<200 {
            let element = arc4random() % 100
            if set.contains(element) {
                set.remove(element)
            } else {
                set.insert(element)
            }
            XCTAssert(set.array.sort() == set.array)
        }
    }
    
    func testIndexOf() {
        var set: SortedSet<UInt32> = []
        for _ in 0..<1000 {
            let element = arc4random() % 1000
            set.insert(element)
            XCTAssert(set.array.indexOf(element) == set.indexOf(element))
        }
    }
    
    func testBruteForceIndexOfPerformance() {
        measureBlock {
            var set: SortedSet<UInt32> = []
            for _ in 0..<1000 {
                let element = arc4random() % 1000
                set.insert(element)
                _ = set.array.indexOf(element)
            }
        }
    }
    
    func testMassiveSet() {
        measureBlock {
            var set: SortedSet<UInt32> = []
            for _ in 0..<10_000 {
                let element = arc4random() % 1000
                set.insert(element)
            }
            for _ in 0..<10_000 {
                let element = arc4random() % 1000
                set.remove(element)
            }
        }
    }
    
    func testIndexOfPerformance() {
        measureBlock {
            var set: SortedSet<UInt32> = []
            for _ in 0..<1000 {
                let element = arc4random() % 1000
                set.insert(element)
                _ = set.indexOf(element)
            }
        }
    }
    
    func testSubtract() {
        XCTAssert(([0, 1, 4, 8, 9] as SortedSet).subtract([2, 8, 9]).array == [0, 1, 4])
    }
    
    func testIntersect() {
        XCTAssert(([-3, -2, 0, 1, 4] as SortedSet).intersect([-4, -2, 1, 2, 4]).array == [-2, 1, 4])
    }
    
    func testUnion() {
        XCTAssert(([-3, 0, 5] as SortedSet).union([-1, 0, 4, 5]).array == [-3, -1, 0, 4, 5])
    }
    
    func testExclusiveOr() {
        XCTAssert(([0, 1, 2, 3] as SortedSet).exclusiveOr([2, 3, 4, 5]).array == [0, 1, 4, 5])
    }
    
}
