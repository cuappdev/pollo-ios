//
//  SavedSessionCell.swift
//  Clicker
//
//  Created by Kevin Chan on 2/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class SavedSessionCell: UITableViewCell {
    
    var sessionLabel: UILabel!
//    var sessionText: String! {
//        didSet {
//            print(sessionText)
//            sessionLabel.text = sessionText
//        }
//    }
    var codeLabel: UILabel!
    
    
    // MARK: - INITIALIZATION
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        backgroundColor = .clickerBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.backgroundColor = UIColor.white.cgColor
        contentView.layer.borderColor = UIColor.clickerBorder.cgColor
        contentView.layer.borderWidth = 0.5
        
        sessionLabel = UILabel()
        sessionLabel.font = UIFont._18RegularFont
        addSubview(sessionLabel)
        
        codeLabel = UILabel()
        codeLabel.font = UIFont._12RegularFont
        codeLabel.textColor = UIColor.clickerDarkGray
        codeLabel.sizeToFit()
        addSubview(codeLabel)
        
        layoutSubviews()
    }
    
    // MARK: - LAYOUT
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 0, 5, 0))
        
        sessionLabel.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.height.equalTo(22)
            make.left.equalToSuperview().offset(38.5)
            make.right.equalToSuperview()
        }
        
        codeLabel.snp.updateConstraints { make in
            make.left.equalTo(sessionLabel.snp.left)
            make.top.equalTo(sessionLabel.snp.bottom).offset(4)
            make.height.equalTo(15)
            make.width.equalToSuperview().multipliedBy(0.7641791045)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

