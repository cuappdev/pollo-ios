//
//  CreateFreeResponseCell.swift
//  Clicker
//
//  Created by Kevin Chan on 2/6/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import SnapKit
import UIKit

class CreateFreeResponseCell: UICollectionViewCell {
    
    var comingSoonLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clickerBackground
        
        comingSoonLabel = UILabel()
        comingSoonLabel.text = "Coming Soon!"
        comingSoonLabel.textColor = .clickerMediumGray
        comingSoonLabel.textAlignment = .center
        comingSoonLabel.font = UIFont._18MediumFont
        addSubview(comingSoonLabel)
        
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        comingSoonLabel.snp.updateConstraints { make in
            make.size.equalTo(CGSize(width: 200, height: 100))
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
