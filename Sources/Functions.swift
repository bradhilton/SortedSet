//
//  Collapse.swift
//  SortedSet
//
//  Created by Bradley Hilton on 2/19/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

internal func copy<T>(_ sortedSet: SortedSet<T>, operate: (inout SortedSet<T>) -> ()) -> SortedSet<T> {
    var copy = sortedSet
    operate(&copy)
    return copy
}

internal func collapse<Element : Hashable, S : Sequence>(_ s: S) -> ([Element], Set<Element>) where S.Iterator.Element == Element {
    var aSet = Set<Element>()
    return (s.filter { set(&aSet, contains: $0) }, aSet)
}

private func set<Element>(_ set: inout Set<Element>, contains element: Element) -> Bool {
    defer { set.insert(element) }
    return !set.contains(element)
}
