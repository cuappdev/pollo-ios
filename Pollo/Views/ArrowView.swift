//
//  ArrowView.swift
//  Pollo
//
//  Created by Matthew Coufal on 10/16/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class ArrowView: UIView {
    
    // MARK: - View vars
    var arrowImageView: UIImageView!
    
    // MARK: - Constants
    let animationDuration: TimeInterval = 0.2
    let bottomInset: CGFloat = 9.8
    let topOffset: CGFloat = 5

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: "DropdownArrowIcon")
        addSubview(arrowImageView)
        
    }
    
    func remake(show: Bool) {
        if show {
            self.arrowImageView.snp.remakeConstraints { remake in
                remake.bottom.equalToSuperview().inset(self.bottomInset)
                remake.centerX.equalToSuperview()
            }
        } else {
            self.arrowImageView.snp.remakeConstraints { remake in
                remake.top.equalToSuperview().offset(self.topOffset)
                remake.centerX.equalToSuperview()
            }
        }
    }
    
    func toggle(show: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: animationDuration) {
                self.remake(show: show)
                self.arrowImageView.superview?.layoutIfNeeded()
            }
        } else {
            remake(show: show)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
