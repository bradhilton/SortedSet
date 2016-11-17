//
//  SortedSet+_ArrayType.swift
//  SortedSet
//
//  Created by Bradley Hilton on 2/20/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

extension SortedSet : ExpressibleByArrayLiteral {
    
    /// Create an instance containing `elements`.
    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
    
    /// If `!self.isEmpty`, remove the last element and return it, otherwise
    /// return `nil`.
    public mutating func popLast() -> Element? {
        guard let last = array.popLast() else { return nil }
        set.remove(last)
        return last
    }
    
}
