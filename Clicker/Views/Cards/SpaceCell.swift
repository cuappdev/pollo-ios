//
//  SpaceCellCollectionViewCell.swift
//  Clicker
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
        spaceView.backgroundColor = .white
        addSubview(spaceView)
        
    }
    
    func configure(with space: CGFloat) {
        spaceView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(space)
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
