//
//  SortedSet+Diff.swift
//  SortedSet
//
//  Created by Bradley Hilton on 8/5/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

public struct Diff : Equatable {
    public var deletes = Set<Int>()
    public var inserts = Set<Int>()
    public var moves = Set<Move>()
    public struct Move : Hashable {
        public let from: Int
        public let to: Int
    }
}

public func ==(lhs: Diff.Move, rhs: Diff.Move) -> Bool {
    return lhs.from == rhs.from && lhs.to == rhs.to
}

public func ==(lhs: Diff, rhs: Diff) -> Bool {
    return lhs.deletes == rhs.deletes && lhs.inserts == rhs.inserts && lhs.moves == rhs.moves
}

extension SortedSet {
    
    static func indices<T>(_ set: SortedSet<T>) -> [Int : Int] {
        var indices = [Int : Int](minimumCapacity: set.count)
        for (index, element) in set.enumerated() {
            indices[element.hashValue] = index
        }
        return indices
    }
    
    // O(2N + M)
    public static func diff(_ source: SortedSet, _ target: SortedSet) -> Diff  {
        var diff = Diff()
        var targetSet = Set(target)
        let targetIndices = indices(target)
        for (index, element) in source.enumerated().reversed() {
            if let newElement = targetSet.remove(element) {
                if element < newElement || element > newElement {
                    diff.moves.insert(Diff.Move(from: index, to: targetIndices[element.hashValue]!))
                }
            } else {
                diff.deletes.insert(index)
            }
        }
        for element in targetSet {
            guard let index = targetIndices[element.hashValue] else {
                continue
            }
            diff.inserts.insert(index)
        }
        return diff
    }
    
}
