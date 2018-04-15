//
//  ResultMCCell.swift
//  Clicker
//
//  Created by Kevin Chan on 3/17/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit


class ResultCell: UITableViewCell {
    
    var containerView: UIView!
    var choiceLabel = UILabel()
    var numberLabel = UILabel()
    var highlightView: UIView!
    var highlightWidthConstraint: Constraint!
    
    //MARK: - INITIALIZATION
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clickerBackground
        
        setupViews()
        layoutSubviews()
    }
    
    //MARK: - LAYOUT
    func setupViews() {
        containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        addSubview(containerView)
        
        choiceLabel.textColor = .clickerDarkGray
        choiceLabel.font = UIFont._16MediumFont
        choiceLabel.textAlignment = .center
        
        containerView.addSubview(choiceLabel)
        
        numberLabel.font = ._16MediumFont
        numberLabel.backgroundColor = .clear
        numberLabel.text = "0"
        numberLabel.textColor = .clickerLightGray
        containerView.addSubview(numberLabel)
        
        highlightView = UIView()
        highlightView.backgroundColor = .clickerMint
        highlightView.layer.cornerRadius = 8
        containerView.addSubview(highlightView)
        containerView.sendSubview(toBack: highlightView)
        
        highlightView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            self.highlightWidthConstraint = make.width.equalTo(0).constraint
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 0, 5, 0))
        
        containerView.snp.updateConstraints { make in
            make.width.equalToSuperview().offset(-36)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
        
        choiceLabel.snp.updateConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.13)
            make.height.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        numberLabel.snp.updateConstraints { make in
            make.size.equalTo(choiceLabel.snp.size)
            make.top.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        highlightView.snp.updateConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
