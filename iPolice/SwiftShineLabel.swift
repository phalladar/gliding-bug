//
//  SwiftShineLabel.swift
//  iPolice
//
//  Created by Joshua Auriemma on 6/10/17.
//  Copyright © 2017 Joshua Auriemma. All rights reserved.
//

import UIKit

class SwiftShineLabel: UILabel {
    var shineDuration : CFTimeInterval = 0
    var fadeoutDuration : CFTimeInterval = 0
    var autoStart: Bool = false
    var shining : Bool {
        get {
            return !(self.displaylink!.isPaused)
        }
    }
    var visible : Bool {
        get {
            return (self.fadeOut == false)
        }
    }
    
    private var attributedString: NSMutableAttributedString?
    private var characterAnimationDurtions = [CFTimeInterval]()
    private var characterAnimationDelays = [CFTimeInterval]()
    private var displaylink: CADisplayLink?
    private var beginTime: CFTimeInterval = 0
    private var endTime: CFTimeInterval = 0
    private var fadeOut: Bool
    private var completion: (() -> Void)?
    
    override internal var text: String? {
        set {
            super.text = newValue
            attributedText = NSMutableAttributedString(string: newValue!)
            
        }
        get {
            return super.text
        }
    }
    
    override internal var attributedText: NSAttributedString? {
        set {
            attributedString = self.initialAttributedString(attributedString: newValue)
            super.attributedText = newValue
            
            for index in 0...newValue!.length - 1 {
                let delay = Double(arc4random_uniform(UInt32(shineDuration / 2 * 100))) / 100.0
                characterAnimationDelays.insert(delay, at: index)
                let remain = shineDuration - delay
                //                characterAnimationDurtions[index] = Double(arc4random_uniform(UInt32(remain * 100))) / 100.0
                characterAnimationDurtions.insert(Double(arc4random_uniform(UInt32(remain * 100))) / 100.0, at: index)
            }
        }
        get {
            return super.attributedText
        }
    }
    convenience init() {
        self.init(frame:CGRect.zero)
    }
    
    override init(frame: CGRect) {
        shineDuration = 2.5
        fadeoutDuration = 2.5
        autoStart = false
        fadeOut = true
        
        super.init(frame: frame)
        self.textColor = .white
        displaylink = CADisplayLink(target: self, selector:#selector(SwiftShineLabel.updateAttributedString))
        displaylink!.isPaused = true
        displaylink!.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.fadeOut = true
        super.init(coder: aDecoder)
    }
    
    override func didMoveToWindow() {
        if (self.window != nil) && self.autoStart {
            self.shine()
        }
    }
    
    internal func updateAttributedString() {
        guard attributedString != nil else { return }
        let now = CACurrentMediaTime()
        for index in 0...attributedString!.length - 1 {
            
            attributedString!.enumerateAttribute(NSForegroundColorAttributeName, in: NSMakeRange(index, 1), options: NSAttributedString.EnumerationOptions(rawValue: 0), using: { (value, range, stop) in
                
                let currentAlpha = ((value as AnyObject).cgColor).alpha
                let checkAlpha = (self.fadeOut && (currentAlpha > 0)) || (!self.fadeOut && (currentAlpha < 1))
                let shouldUpdateAlpha : Bool = checkAlpha || (now - self.beginTime) >= self.characterAnimationDelays[index]
                if !shouldUpdateAlpha {
                    return
                }
                
                var percentage = (now - self.beginTime - self.characterAnimationDelays[index]) / (self.characterAnimationDurtions[index])
                if (self.fadeOut) {
                    percentage = 1 - percentage
                }
                
                let color = self.textColor.withAlphaComponent(CGFloat(percentage))
                self.attributedString!.addAttributes([NSForegroundColorAttributeName : color], range: range)
            })
        }
        
        super.attributedText = attributedString
        if now > endTime {
            displaylink!.isPaused = true
            if self.completion != nil {
                self.completion!()
            }
        }
    }
    
    
    internal func initialAttributedString(attributedString: NSAttributedString?) -> NSMutableAttributedString? {
        if attributedString == nil {
            return nil
        }
        
        let mutableAttributedString = attributedString!.mutableCopy() as! NSMutableAttributedString
        let color = textColor.withAlphaComponent(0)
        mutableAttributedString.addAttributes([NSForegroundColorAttributeName : color], range: NSMakeRange(0, mutableAttributedString.length))
        
        return mutableAttributedString
    }
    
    func shine() {
        shineWithCompletion(completion: nil)
    }
    
    func shineWithCompletion(completion: (() -> Void)?) {
        if (!self.shining) && (self.fadeOut) {
            self.completion = completion
            fadeOut = false
            startAnimation(duration: fadeoutDuration)
        }
    }
    
    func fadeout() {
        fadeOutWithCompletion(completion: nil)
    }
    
    func fadeOutWithCompletion(completion: (() -> Void)?) {
        if (!self.shining) && (!self.fadeOut) {
            self.completion = completion
            fadeOut = true
            startAnimation(duration: fadeoutDuration)
        }
    }
    
    func startAnimation(duration duration: CFTimeInterval) {
        beginTime = CACurrentMediaTime()
        endTime = beginTime + shineDuration
        displaylink!.isPaused = false
    }
}
