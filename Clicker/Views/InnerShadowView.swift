//
//  InnerShadowView.swift
//  Clicker
//
//  Created by Matthew Coufal on 10/13/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class InnerShadowLayer: CAShapeLayer {
    
    override init() {
        super.init()
        initShadow()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initShadow()
    }
    
    override var shadowOffset: CGSize {
        didSet {
            setNeedsLayout()
        }
    }
    
    override var shadowOpacity: Float {
        didSet {
            setNeedsLayout()
        }
    }
    
    override var shadowRadius: CGFloat {
        didSet {
            setNeedsLayout()
        }
    }
    
    override var shadowColor: CGColor? {
        didSet {
            setNeedsLayout()
        }
    }
    
    func initShadow() {
        masksToBounds = true
        shouldRasterize = true
        
        fillRule = kCAFillRuleEvenOdd
        borderColor = UIColor.clear.cgColor
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        
        generateShadowPath()
    }
    
    func generateShadowPath() {
        let top = shadowRadius - shadowOffset.height
        let bottom = shadowRadius + shadowOffset.height
        let left = shadowRadius - shadowOffset.width
        let right = shadowRadius + shadowOffset.width
        let shadowRect = CGRect(x: bounds.origin.x - left,
                                y: bounds.origin.y - top,
                                width: bounds.width + left + right,
                                height: bounds.height + top + bottom)
        
        let path = CGMutablePath()
        let delta: CGFloat = 1
        let rect = CGRect(x: bounds.origin.x - delta, y: bounds.origin.y - delta, width: bounds.width + delta * 2, height: bounds.height + delta * 2)
        let bezier: UIBezierPath = {
            if cornerRadius > 0 {
                return UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            } else {
                return UIBezierPath(rect: rect)
            }
        }()
        path.addPath(bezier.cgPath)
        path.addRect(shadowRect)
        path.closeSubpath()
        self.path = path
    }
    
}

class InnerShadowView: UIView {
    
    var shadowLayer = InnerShadowLayer()
    
    override var bounds: CGRect {
        didSet {
            shadowLayer.frame = bounds
        }
    }
    
    override var frame: CGRect {
        didSet {
            shadowLayer.frame = bounds
        }
    }
    
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            shadowLayer.cornerRadius = cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initShadowLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initShadowLayer()
    }
    
    func initShadowLayer() {
        layer.addSublayer(shadowLayer)
    }
    
}
