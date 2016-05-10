//
//  Collapse.swift
//  SortedSet
//
//  Created by Bradley Hilton on 2/19/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

internal func copy<T>(sortedSet: SortedSet<T>, operate: (inout SortedSet<T>) -> ()) -> SortedSet<T> {
    var copy = sortedSet
    operate(&copy)
    return copy
}

internal func collapse<Element : Hashable, S : SequenceType where S.Generator.Element == Element>(s: S) -> ([Element], Set<Element>) {
    var aSet = Set<Element>()
    return (s.filter { set(&aSet, contains: $0) }, aSet)
}

private func set<Element : Hashable>(inout set: Set<Element>, contains element: Element) -> Bool {
    defer { set.insert(element) }
    return !set.contains(element)
}
