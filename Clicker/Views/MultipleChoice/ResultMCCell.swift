//
//  ResultMCCell.swift
//  Clicker
//
//  Created by Kevin Chan on 3/17/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit


class ResultMCCell: UITableViewCell {
    
    var containerView: UIView!
    var choiceLabel = UILabel()
    var choiceTag: Int! {
        didSet {
            choiceLabel.text = intToMCOption(choiceTag)
        }
    }
    var optionLabel = UILabel()
    var numberLabel = UILabel()
    var highlightView: UIView!
    var highlightWidthConstraint: Constraint!
    
    //MARK: - INITIALIZATION
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clickerBackground
//        contentView.layer.cornerRadius = 8
//        contentView.layer.borderColor = UIColor.clickerBorder.cgColor
//        contentView.layer.borderWidth = 0.5
//        clipsToBounds = true
        
        setupViews()
        layoutSubviews()
    }
    
    //MARK: - LAYOUT
    func setupViews() {
        containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        containerView.layer.borderColor = UIColor.clickerBorder.cgColor
        containerView.layer.borderWidth = 0.5
        containerView.clipsToBounds = true
        addSubview(containerView)
        
        choiceLabel.textColor = .clickerDarkGray
        choiceLabel.font = UIFont._16SemiboldFont
        choiceLabel.textAlignment = .center
        containerView.addSubview(choiceLabel)
        
        optionLabel.font = UIFont._16SemiboldFont
        optionLabel.backgroundColor = .clear
        containerView.addSubview(optionLabel)
        
        numberLabel.font = ._16RegularFont
        numberLabel.backgroundColor = .clear
        numberLabel.text = "0"
        containerView.addSubview(numberLabel)
        
        highlightView = UIView()
        highlightView.backgroundColor = .clickerLightBlue
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
        
        optionLabel.snp.updateConstraints { make in
            make.left.equalTo(choiceLabel.snp.right)
            make.right.equalTo(numberLabel.snp.left)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
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
