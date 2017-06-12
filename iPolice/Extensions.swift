//
//  Extensions.swift
//  iPolice
//
//  Created by Joshua Auriemma on 6/11/17.
//  Copyright © 2017 Joshua Auriemma. All rights reserved.
//

import Foundation

extension Array {
    func shiftRight(_ amount: Int = 1) -> [Element] {
        var amt = amount
        assert(-count...count ~= amt, "Shift amount out of bounds")
        if amt < 0 { amt += count }  // this needs to be >= 0
        return Array(self[amt ..< count] + self[0 ..< amt])
    }
    
    mutating func shiftRightInPlace(amount: Int = 1) {
        self = shiftRight(amount)
    }
}
