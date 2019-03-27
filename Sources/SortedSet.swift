//
//  SortedSet.swift
//  SortedSet
//
//  Created by Bradley Hilton on 2/19/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

/// An ordered collection of unique `Element` instances
public struct SortedSet<Element : Hashable & Comparable> : Hashable, RandomAccessCollection {
    
    public typealias Indices = DefaultIndices<SortedSet<Element>>

    var array: [Element]
    var set: Set<Element>
    
    /// Always zero, which is the index of the first element when non-empty.
    public var startIndex: Int {
        return array.startIndex
    }
    
    /// A "past-the-end" element index; the successor of the last valid
    /// subscript argument.
    public var endIndex: Int {
        return array.endIndex
    }
    
    public func index(after i: Int) -> Int {
        return array.index(after: i)
    }
    
    public func index(before i: Int) -> Int {
        return array.index(before: i)
    }
    
    public subscript(position: Int) -> Element {
        return array[position]
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(set)
    }
    
    public func indexOf(_ element: Element) -> Int? {
        guard set.contains(element) else { return nil }
        return indexOf(element, in: range)
    }
    
    var range: Range<Int> {
        return Range(uncheckedBounds: (startIndex, endIndex))
    }
    
    func indexOf(_ element: Element, in range: Range<Int>) -> Int {
        guard range.count > 2 else {
            return element == array[range.lowerBound] ? range.lowerBound : (range.upperBound - 1)
        }
        let middleIndex = (range.lowerBound + range.upperBound)/2
        let middle = self[middleIndex]
        if element < middle {
            return indexOf(element, in: range.lowerBound..<middleIndex)
        } else {
            return indexOf(element, in: middleIndex..<range.upperBound)
        }
    }
    
    /// Construct from an arbitrary sequence with elements of type `Element`.
    public init<S : Sequence>(_ s: S, presorted: Bool = false, noDuplicates: Bool = false) where S.Iterator.Element == Element {
        if noDuplicates {
            if presorted {
                (self.array, self.set) = (Array(s), Set(s))
            } else {
                (self.array, self.set) = (s.sorted(), Set(s))
            }
        } else {
            if presorted {
                (self.array, self.set) = collapse(s)
            } else {
                (self.array, self.set) = collapse(s.sorted())
            }
        }
    }
    
    /// Construct an empty SortedSet.
    public init() {
        self.array = []
        self.set = []
    }
    
}


public func ==<T>(lhs: SortedSet<T>, rhs: SortedSet<T>) -> Bool {
    guard lhs.count == rhs.count else {
        return false
    }
    for (lhs, rhs) in zip(lhs, rhs) where lhs != rhs {
        return false
    }
    return true
}

extension Array where Element : Comparable & Hashable {
    
    /// Cast SortedSet as an Array
    public init(_ sortedSet: SortedSet<Element>) {
        self = sortedSet.array
    }
    
}

extension Set where Element : Comparable {
    
    /// Cast SortedSet as a Set
    public init(_ sortedSet: SortedSet<Element>) {
        self = sortedSet.set
    }
    
}


