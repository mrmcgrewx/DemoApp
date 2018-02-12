//
//  FancyButton.swift
//  BareBone
//
//  Created by Kyle McGrew on 2/9/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import UIKit

@IBDesignable
class FancyButton: UIButton {
    @IBInspectable var borderColor: UIColor = UIColor.customButton
    @IBInspectable var borderWidth: CGFloat = 1
    @IBInspectable var cornerRadius: CGFloat = 8
    
    @IBInspectable var topColor: UIColor = UIColor.white
    @IBInspectable var bottomColor: UIColor = UIColor.customButton
    
    override func draw(_ rect: CGRect) {
        
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        
        setBackgroundImage(bgImage(enabled: true), for: .normal)
        setBackgroundImage(bgImage(enabled: false), for: .disabled)
    }
    
    override var isEnabled: Bool {
        set {
            super.isEnabled = newValue
            backgroundColor = newValue ? .customButton : .clear
        }
        get { return super.isEnabled }
    }
    
    override var isExclusiveTouch: Bool {
        set {
            super.isExclusiveTouch = true
        }
        get {
            return super.isExclusiveTouch
        }
    }
    
    private func bgImage(enabled: Bool) -> UIImage {
        UIGraphicsBeginImageContext(bounds.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.customButton.withAlphaComponent(enabled ? 1.0 : 0.6).cgColor)
        context?.fill(bounds)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
