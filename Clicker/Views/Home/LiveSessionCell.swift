//
//  LiveSessionCell.swift
//  Clicker
//
//  Created by Keivan Shahida on 2/19/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class LiveSessionCell: UITableViewCell {
    
    var sessionLabel: UILabel!
    var codeLabel: UILabel!
    var liveIcon: UIImageView!
    var rightArrowIcon: UIImageView!
    
    // var date: String! = "Started 3 minutes ago by Dan Li"
    
    // MARK: - INITIALIZATION
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clickerBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.backgroundColor = UIColor.white.cgColor
        contentView.layer.borderColor = UIColor.clickerBorder.cgColor
        contentView.layer.borderWidth = 0.5
        
        liveIcon = UIImageView(image: #imageLiteral(resourceName: "liveIcon"))
        addSubview(liveIcon)
        
        rightArrowIcon = UIImageView(image: #imageLiteral(resourceName: "backArrow"))
        addSubview(rightArrowIcon)
        
        sessionLabel = UILabel()
        sessionLabel.font = UIFont._18SemiboldFont
        sessionLabel.textColor = UIColor.clickerBlack
        sessionLabel.sizeToFit()
        addSubview(sessionLabel)
        
        codeLabel = UILabel()
        codeLabel.font = UIFont._12RegularFont
        codeLabel.textColor = UIColor.clickerDarkGray
        codeLabel.sizeToFit()
        addSubview(codeLabel)
    }
    
    // MARK: - LAYOUT
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 18, 0, -10))

        liveIcon.snp.updateConstraints { make in
            make.left.equalToSuperview().offset(36)
            make.centerY.equalTo(sessionLabel)
            make.width.equalTo(10)
            make.height.equalTo(10)
        }
        
        rightArrowIcon.snp.updateConstraints { make in
            make.right.equalTo(contentView.snp.right).offset(-28)
            make.centerY.equalToSuperview()
            make.height.equalTo(13)
            make.width.equalTo(8)
        }
        
        sessionLabel.snp.updateConstraints { make in
            make.left.equalTo(liveIcon.snp.right).offset(10)
            make.top.equalToSuperview().offset(18)
            make.height.equalTo(22)
            make.width.equalToSuperview().multipliedBy(0.76)
        }
        
        codeLabel.snp.updateConstraints { make in
            make.left.equalTo(liveIcon.snp.right).offset(10)
            make.top.equalTo(sessionLabel.snp.bottom).offset(4)
            make.height.equalTo(15)
            make.width.equalToSuperview().multipliedBy(0.76)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
