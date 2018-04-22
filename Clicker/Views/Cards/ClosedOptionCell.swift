//
//  ClosedOptionCell.swift
//  Clicker
//
//  Created by eoin on 4/17/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class ClosedOptionCell: UITableViewCell {
    
    var questionLabel: UILabel!
    var chosen: Bool!
    var index: Int!
    
    //MARK: - INITIALIZATION
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clickerBackground
        
        setupViews()
        layoutSubviews()
        
        selectionStyle = .none
    }
    
    //MARK: - LAYOUT
    func setupViews() {
        questionLabel = UILabel()
        print("seting up cell \(index)")
        questionLabel.layer.cornerRadius = 8
        questionLabel.clipsToBounds = true
        questionLabel.layer.borderWidth = 1.0
        questionLabel.layer.borderColor = UIColor.clickerMint.cgColor
        questionLabel.textAlignment = .center
        addSubview(questionLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 0, 5, 0))
        
        questionLabel.snp.updateConstraints { make in
            make.width.equalToSuperview().offset(-36)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    func setColors() {
        if chosen {
            questionLabel.backgroundColor = .clickerMint
            questionLabel.textColor = .clickerWhite
        }
        else {
            questionLabel.backgroundColor = .clickerWhite
            questionLabel.textColor = .clickerMint
        }
    }
    

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


