//
//  OptionsGradientView.swift
//  Pollo
//
//  Created by Gonzalo Gonzalez on 3/7/20.
//  Copyright © 2020 CornellAppDev. All rights reserved.
//

import UIKit

class OptionsGradientView: UIView {

    // MARK: - View vars
    let gradientLayer = CAGradientLayer()
    
    // MARK: - Constants
    let animationDuration: TimeInterval = 0.2
    let bottomInset: CGFloat = 9.8
    let topOffset: CGFloat = 5

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = false
        
        gradientLayer.frame = frame
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        //gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.25)
        layer.addSublayer(gradientLayer)
    }
    
    func toggle(show: Bool, animated: Bool) {
        let opacity = CGFloat(show ? 1 : 0)
        if animated {
            UIView.animate(withDuration: animationDuration) {
                self.alpha = opacity
            }
        } else {
            self.alpha = opacity
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
