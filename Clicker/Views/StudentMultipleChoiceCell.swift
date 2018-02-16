//
//  StudentMultipleChoiceCell.swift
//  Clicker
//
//  Created by Keivan Shahida on 2/16/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class StudentMultipleChoiceCell: UITableViewCell {
    
    var option: String!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clickerBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.clickerBorder.cgColor
        contentView.layer.borderWidth = 0.5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 18, 5, 18))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            contentView.layer.borderColor = UIColor.clickerBlue.cgColor
            contentView.layer.borderWidth = 2.0
        } else {
            contentView.layer.borderColor = UIColor.clickerBorder.cgColor
            contentView.layer.borderWidth = 0.5
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            contentView.layer.borderColor = UIColor.clickerBlue.cgColor
            contentView.layer.borderWidth = 2.0
        } else {
            contentView.layer.borderColor = UIColor.clickerBorder.cgColor
            contentView.layer.borderWidth = 0.5
        }
    }
}
