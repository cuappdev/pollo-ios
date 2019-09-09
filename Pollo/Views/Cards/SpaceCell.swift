//
//  SpaceCellCollectionViewCell.swift
//  Pollo
//
//  Created by Matthew Coufal on 10/13/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class SpaceCell: UICollectionViewCell {
    
    var spaceView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        spaceView = UIView()
        contentView.addSubview(spaceView)
        
        spaceView.snp.makeConstraints { make in
            make.center.width.equalToSuperview()
            make.height.equalTo(0)
        }
        
    }
    
    func configure(with space: CGFloat, backgroundColor: UIColor) {
        spaceView.backgroundColor = backgroundColor
        spaceView.snp.updateConstraints { update in
            update.height.equalTo(space)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
