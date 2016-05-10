//
//  SortedSet.swift
//  SortedSet
//
//  Created by Bradley Hilton on 2/19/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

/// An ordered collection of unique `Element` instances
public struct SortedSet<Element : protocol<Hashable, Comparable>> : Hashable, CollectionType {

    internal(set) var array: [Element]
    internal(set) var set: Set<Element>
    
    /// Always zero, which is the index of the first element when non-empty.
    public var startIndex: Int {
        return array.startIndex
    }
    
    /// A "past-the-end" element index; the successor of the last valid
    /// subscript argument.
    public var endIndex: Int {
        return array.endIndex
    }
    
    public subscript(position: Int) -> Element {
        return array[position]
    }
    
    public var hashValue: Int {
        return set.hashValue
    }
    
    @warn_unused_result
    public func indexOf(element: Element) -> Int? {
        guard set.contains(element) else { return nil }
        return indexOf(element, in: indices)
    }
    
    func indexOf(element: Element, in range: Range<Int>) -> Int {
        guard range.count > 2 else {
            return element == array[range.startIndex] ? range.startIndex : range.endIndex.predecessor()
        }
        let middleIndex = (range.startIndex + range.endIndex)/2
        let middle = self[middleIndex]
        if element < middle {
            return indexOf(element, in: range.startIndex..<middleIndex)
        } else {
            return indexOf(element, in: middleIndex..<range.endIndex)
        }
    }
    
    /// Construct from an arbitrary sequence with elements of type `Element`.
    public init<S : SequenceType where S.Generator.Element == Element>(_ s: S, presorted: Bool = false, noDuplicates: Bool = false) {
        if noDuplicates {
            if presorted {
                (self.array, self.set) = (Array(s), Set(s))
            } else {
                (self.array, self.set) = (s.sort(), Set(s))
            }
        } else {
            if presorted {
                (self.array, self.set) = collapse(s)
            } else {
                (self.array, self.set) = collapse(s.sort())
            }
        }
    }
    
    /// Construct an empty SortedSet.
    public init() {
        self.array = []
        self.set = []
    }
    
}

@warn_unused_result
public func ==<T : protocol<Hashable, Comparable>>(lhs: SortedSet<T>, rhs: SortedSet<T>) -> Bool {
    guard lhs.count == rhs.count else {
        return false
    }
    for (lhs, rhs) in zip(lhs, rhs) where lhs != rhs {
        return false
    }
    return true
}


