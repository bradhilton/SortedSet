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
        func test(_ initial: SortedSet<Int>, insert element: Int, assert expected: SortedSet<Int>) {
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
        func test(_ initial: SortedSet<Int>, remove element: Int, assert expected: SortedSet<Int>) {
            var array = initial
            _ = array.remove(element)
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
                _ = set.remove(element)
            } else {
                set.insert(element)
            }
            XCTAssert(set.array.sorted() == set.array)
        }
    }
    
    func testIndexOf() {
        var set: SortedSet<UInt32> = []
        for _ in 0..<1000 {
            let element = arc4random() % 1000
            set.insert(element)
            XCTAssert(set.array.firstIndex(of: element) == set.indexOf(element))
        }
    }
    
    func testBruteForceIndexOfPerformance() {
        measure {
            var set: SortedSet<UInt32> = []
            for _ in 0..<1000 {
                let element = arc4random() % 1000
                set.insert(element)
                _ = set.array.firstIndex(of: element)
            }
        }
    }
    
    func testMassiveSet() {
        measure {
            var set: SortedSet<UInt32> = []
            for _ in 0..<10_000 {
                let element = arc4random() % 1000
                set.insert(element)
            }
            for _ in 0..<10_000 {
                let element = arc4random() % 1000
                _ = set.remove(element)
            }
        }
    }
    
    func testIndexOfPerformance() {
        measure {
            var set: SortedSet<UInt32> = []
            for _ in 0..<1000 {
                let element = arc4random() % 1000
                set.insert(element)
                _ = set.indexOf(element)
            }
        }
    }
    
    func testSubtract() {
        XCTAssert(([0, 1, 4, 8, 9] as SortedSet).subtracting([2, 8, 9]).array == [0, 1, 4])
    }
    
    func testIntersect() {
        XCTAssert(([-3, -2, 0, 1, 4] as SortedSet).intersection([-4, -2, 1, 2, 4]).array == [-2, 1, 4])
    }
    
    func testUnion() {
        XCTAssert(([-3, 0, 5] as SortedSet).union([-1, 0, 4, 5]).array == [-3, -1, 0, 4, 5])
    }
    
    func testExclusiveOr() {
        XCTAssert(([0, 1, 2, 3] as SortedSet).symmetricDifference([2, 3, 4, 5]).array == [0, 1, 4, 5])
    }
    
    func testDiff() {
        let source: SortedSet = [
            Person(hashValue: 0, name: "A"),
            Person(hashValue: 1, name: "C"),
            Person(hashValue: 2, name: "D"),
            Person(hashValue: 3, name: "G"),
            Person(hashValue: 4, name: "L"),
            Person(hashValue: 5, name: "M"),
            Person(hashValue: 6, name: "Q"),
            Person(hashValue: 7, name: "U")
        ]
        let target: SortedSet = [
            Person(hashValue: 0, name: "W"),
            Person(hashValue: 2, name: "D"),
            Person(hashValue: 3, name: "G"),
            Person(hashValue: 4, name: "L"),
            Person(hashValue: 6, name: "Q"),
            Person(hashValue: 7, name: "C"),
            Person(hashValue: 8, name: "B"),
            Person(hashValue: 9, name: "F"),
            Person(hashValue: 10, name: "J")
        ]
        let expected = Diff(deletes: [1, 5],
                            inserts: [0, 3, 5],
                            moves: [.init(from: 0, to: 8), .init(from: 7, to: 1)])
        let result = SortedSet<Person>.diff(source, target)
        XCTAssertEqual(expected, result)
    }
    
    func testDiffPerformance() {
        let source = largeRandomSet(iterations: 10_000, range: 10_000)
        let target = largeRandomSet(iterations: 10_000, range: 10_000)
        measure {
            _ = SortedSet<UInt32>.diff(source, target)
        }
    }
    
    func largeRandomSet(iterations: Int, range: UInt32) -> SortedSet<UInt32> {
        var set: SortedSet<UInt32> = []
        for _ in 0..<iterations {
            let element = arc4random() % range
            set.insert(element)
        }
        return set
    }
    
}

struct Person : Hashable, Comparable {
    let hashValue: Int
    let name: String
}

func ==(lhs: Person, rhs: Person) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

func <(lhs: Person, rhs: Person) -> Bool {
    return lhs.name < rhs.name
}


