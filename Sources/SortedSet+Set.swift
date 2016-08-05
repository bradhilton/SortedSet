//
//  SortedSet+Set.swift
//  SortedSet
//
//  Created by Bradley Hilton on 2/20/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

extension SortedSet {
    
    public init(minimumCapacity: Int) {
        self.array = []
        self.set = Set(minimumCapacity: minimumCapacity)
    }

    /// Returns `true` if the sorted set contains a member.
    @warn_unused_result
    public func contains(member: Element) -> Bool {
        return set.contains(member)
    }
    
    /// Insert a member into the sorted set.
    public mutating func insert(member: Element) {
        remove(member)
        insert(member, into: indices)
        set.insert(member)
    }
    
    private mutating func insert(member: Element, into range: Range<Int>) {
        if range.count == 0 {
            return array.insert(member, atIndex: range.startIndex)
        } else if member < self[range.startIndex] {
            return array.insert(member, atIndex: range.startIndex)
        } else if member > self[range.endIndex - 1] {
            return array.insert(member, atIndex: range.endIndex)
        } else if range.count == 2 {
            return array.insert(member, atIndex: range.startIndex + 1)
        } else  {
            let middleIndex = (range.startIndex + range.endIndex)/2
            let middle = self[middleIndex]
            if member < middle {
                insert(member, into: range.startIndex..<middleIndex)
            } else {
                insert(member, into: middleIndex..<range.endIndex)
            }
        }
    }
    
    /// Remove the member from the sorted set and return it if it was present.
    public mutating func remove(member: Element) -> Element? {
        return set.remove(member).map { array.removeAtIndex(indexOf($0, in: indices)) }
    }

    /// Returns true if the sorted set is a subset of a finite sequence as a `Set`.
    @warn_unused_result
    public func isSubsetOf<S : SequenceType where S.Generator.Element == Element>(sequence: S) -> Bool {
        return set.isSubsetOf(sequence)
    }

    /// Returns true if the sorted set is a subset of a finite sequence as a `Set`
    /// but not equal.
    @warn_unused_result
    public func isStrictSubsetOf<S : SequenceType where S.Generator.Element == Element>(sequence: S) -> Bool {
        return set.isStrictSubsetOf(sequence)
    }

    /// Returns true if the sorted set is a superset of a finite sequence as a `Set`.
    @warn_unused_result
    public func isSupersetOf<S : SequenceType where S.Generator.Element == Element>(sequence: S) -> Bool {
        return set.isSupersetOf(sequence)
    }

    /// Returns true if the sorted set is a superset of a finite sequence as a `Set`
    /// but not equal.
    @warn_unused_result
    public func isStrictSupersetOf<S : SequenceType where S.Generator.Element == Element>(sequence: S) -> Bool {
        return set.isStrictSupersetOf(sequence)
    }

    /// Returns true if no members in the sorted set are in a finite sequence as a `Set`.
    @warn_unused_result
    public func isDisjointWith<S : SequenceType where S.Generator.Element == Element>(sequence: S) -> Bool {
        return set.isDisjointWith(sequence)
    }

    /// Return a new `SortedSet` with items in both this set and a finite sequence.
    @warn_unused_result
    public func union<S : SequenceType where S.Generator.Element == Element>(sequence: S) -> SortedSet {
        return copy(self) { (inout set: SortedSet) in set.unionInPlace(sequence) }
    }
    
    /// Append elements of a finite sequence into this `SortedSet`.
    public mutating func unionInPlace<S : SequenceType where S.Generator.Element == Element>(sequence: S) {
        for member in sequence {
            insert(member)
        }
    }

    /// Return a new sorted set with elements in this set that do not occur
    /// in a finite sequence.
    @warn_unused_result
    public func subtract<S : SequenceType where S.Generator.Element == Element>(sequence: S) -> SortedSet {
        return copy(self) { (inout set: SortedSet) in set.subtractInPlace(sequence) }
    }

    /// Remove all members in the sorted set that occur in a finite sequence.
    public mutating func subtractInPlace<S : SequenceType where S.Generator.Element == Element>(sequence: S) {
        set.subtractInPlace(sequence)
        array = array.filter { set.contains($0) }
    }
    
    /// Return a new sorted set with elements common to this sorted set and a finite sequence.
    @warn_unused_result
    public func intersect<S : SequenceType where S.Generator.Element == Element>(sequence: S) -> SortedSet {
        return copy(self) { (inout set: SortedSet) in set.intersectInPlace(sequence) }
    }
    
    /// Remove any members of this sorted set that aren't also in a finite sequence.
    public mutating func intersectInPlace<S : SequenceType where S.Generator.Element == Element>(sequence: S) {
        set.intersectInPlace(sequence)
        array = array.filter { set.contains($0) }
    }

    /// Return a new sorted set with elements that are either in the sorted set or a finite
    /// sequence but do not occur in both.
    @warn_unused_result
    public func exclusiveOr<S : SequenceType where S.Generator.Element == Element>(sequence: S) -> SortedSet {
        return copy(self) { (inout set: SortedSet) in set.exclusiveOrInPlace(sequence) }
    }

    /// For each element of a finite sequence, remove it from the sorted set if it is a
    /// common element, otherwise add it to the sorted set. Repeated elements of the
    /// sequence will be ignored.
    public mutating func exclusiveOrInPlace<S : SequenceType where S.Generator.Element == Element>(sequence: S) {
        set.exclusiveOrInPlace(sequence)
        for member in sequence {
            insert(member, into: indices)
        }
        self.array = array.filter { set.contains($0) }
    }
    
    /// If `!self.isEmpty`, remove the first element and return it, otherwise
    /// return `nil`.
    public mutating func popFirst() -> Element? {
        guard let first = array.first else { return nil }
        set.remove(first)
        return array.removeFirst()
    }
    
}
