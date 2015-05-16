//
//  ImagePicker.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 05/05/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import UIKit
import QuartzCore

class ImagePickerView: UIControl {
    
    let backgroundLayer = CAShapeLayer()
    let maskLayer = CAShapeLayer()
    let photoLayer = CALayer()
    
    var image: UIImage? {
        didSet {
            photoLayer.contents = image?.CGImage
            photoLayer.frame = bounds
        }
    }
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        
        
        // BG Layer
        backgroundLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .AllCorners, cornerRadii: CGSize(width: 5.0, height: 5.0)).CGPath
        backgroundLayer.fillColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0).CGColor
        
        layer.addSublayer(backgroundLayer)
        
        // Placeholder
        let placeholderImage = UIImage(named: "productPlaceholder")!
        photoLayer.contents = placeholderImage.CGImage
        photoLayer.frame = CGRect(x: (bounds.size.width - placeholderImage.size.width)/2, y: (bounds.size.height - placeholderImage.size.height)/2, width: placeholderImage.size.width, height: placeholderImage.size.height)
        
        layer.addSublayer(photoLayer)
        
        maskLayer.path = backgroundLayer.path
        
        backgroundLayer.mask = maskLayer
        photoLayer.mask = maskLayer
        
    }
    
}
