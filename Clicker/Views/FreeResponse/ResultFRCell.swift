//
//  ResultFRCell.swift
//  Clicker
//
//  Created by Kevin Chan on 3/17/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class ResultFRCell: UITableViewCell {
    
    var freeResponseLabel: UILabel!
    
    //MARK: - INITIALIZATION
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clickerBackground
        contentView.backgroundColor = .white
        clipsToBounds = true
        
        setupViews()
        layoutSubviews()
    }
    
    //MARK: - LAYOUT
    func setupViews() {
        freeResponseLabel = UILabel()
        freeResponseLabel.font = UIFont._16RegularFont
        freeResponseLabel.backgroundColor = .white
        freeResponseLabel.lineBreakMode = .byWordWrapping
        freeResponseLabel.numberOfLines = 0
        addSubview(freeResponseLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 0, 5, 0))
        
        freeResponseLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(contentView.snp.height)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
