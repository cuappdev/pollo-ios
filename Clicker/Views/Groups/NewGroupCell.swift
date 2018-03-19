//
//  NewGroupCell.swift
//  Clicker
//
//  Created by eoin on 3/18/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class NewGroupCell: UICollectionViewCell {
    
    var welcomeLabel: UILabel!
    var subtitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        layoutSubviews()
    }
    
    func setupViews() {
        welcomeLabel = UILabel()
        welcomeLabel.text = "Welcome!"
        welcomeLabel.font = ._21SemiboldFont
        welcomeLabel.textAlignment = .center
        addSubview(welcomeLabel)
        
        subtitle = UILabel()
        subtitle.text = "Create a question below to get started."
        subtitle.font = ._16SemiboldFont
        subtitle.textAlignment = .center
        subtitle.lineBreakMode = .byWordWrapping
        subtitle.numberOfLines = 0
        subtitle.textColor = .clickerMediumGray
        addSubview(subtitle)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        welcomeLabel.snp.updateConstraints{ make in
            make.top.equalToSuperview().offset(36)
            make.width.equalToSuperview()
            make.height.equalTo(25)
            make.centerX.equalToSuperview()
        }
        
        subtitle.snp.updateConstraints{ make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(18)
            make.width.equalTo(250)
            make.height.equalTo(46)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
