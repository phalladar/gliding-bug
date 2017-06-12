//
//  Ball.swift
//  iPolice
//
//  Created by Joshua Auriemma on 6/10/17.
//  Copyright © 2017 Joshua Auriemma. All rights reserved.
//

import UIKit

@IBDesignable
class Ball: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
}
