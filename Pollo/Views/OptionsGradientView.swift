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
    private let animationDuration: TimeInterval = 0.2

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = false
        
        gradientLayer.frame = frame
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = frame
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
