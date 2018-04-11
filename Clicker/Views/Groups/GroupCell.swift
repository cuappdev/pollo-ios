//
//  GroupCell.swift
//  Clicker
//
//  Created by Kevin Chan on 4/11/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation
import UIKit

class GroupCell: UITableViewCell {
    
    var nameLabel: UILabel!
    var rightArrowIcon: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        layoutSubviews()
    }
    
    func setupViews() {
        nameLabel = UILabel()
        nameLabel.font = UIFont._18RegularFont
        addSubview(nameLabel)
        
        rightArrowIcon = UIImageView(image: #imageLiteral(resourceName: "backArrow"))
        addSubview(rightArrowIcon)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.snp.makeConstraints { make in
            make.width.equalTo(nameLabel.intrinsicContentSize.width)
            make.height.equalTo(24)
            make.top.equalToSuperview().offset(18)
            make.left.equalToSuperview().offset(18)
        }
        
        rightArrowIcon.snp.updateConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.height.equalTo(13)
            make.width.equalTo(8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
