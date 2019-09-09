//
//  HamburgerCardCell.swift
//  Pollo
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class HamburgerCardCell: UICollectionViewCell {
    
    // MARK: - Constants
    let contentViewCornerRadius: CGFloat = 12
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = contentViewCornerRadius
        contentView.layer.borderWidth = 0
    }
    
    // MARK: - Configure
    func configure(for hamburgerCardModel: HamburgerCardModel) {
        switch hamburgerCardModel.state {
        case .top:
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            contentView.backgroundColor = .clickerWhite
        case .bottom:
            contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            contentView.backgroundColor = .white
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
