//
//  FlatButton.swift
//  Cystal-Example
//
//  Created by yunhao on 2020/8/13.
//  Copyright © 2020 yunhao. All rights reserved.
//

import UIKit

@IBDesignable
class FlatButton: UIButton {
    
    @IBInspectable
    var name: String?
    
    @IBInspectable
    var flatColor: UIColor = .systemBlue {
        didSet {
            setBackgroundColor(flatColor, cornerRadius: cornerRadius, for: .normal)
        }
    }
    
    var cornerRadius: CGFloat = 11.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setShadow()
    }
    
    func setShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = .zero
    }
    
    func setBackgroundColor(_ color: UIColor?, cornerRadius: CGFloat = 8.0, for state: UIControl.State) {
        guard let color = color else {
            self.setBackgroundImage(nil, for: state)
            return
        }
        
        // Create a resizable image.
        let length = 1 + cornerRadius * 2
        let size = CGSize(width: length, height: length)
        let rect = CGRect(origin: .zero, size: size)
        // Create color image.
        var backgroundImage = UIGraphicsImageRenderer(size: size).image { (context) in
            color.setFill()
            UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).fill()
        }
        // Create a resizable background image.
        backgroundImage = backgroundImage.resizableImage(
            withCapInsets: UIEdgeInsets(
                top: cornerRadius,
                left: cornerRadius,
                bottom: cornerRadius,
                right: cornerRadius
            )
        )
        
        self.setBackgroundImage(backgroundImage, for: state)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setShadow()
    }
}
