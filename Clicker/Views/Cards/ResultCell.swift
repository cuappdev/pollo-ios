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
    var optionLabel: UILabel!
    var numberLabel: UILabel!
    var highlightView: UIView!
    var highlightWidthConstraint: Constraint!
    var choiceTag: Int!

    
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
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.clickerBorder.cgColor
        addSubview(containerView)

        optionLabel = UILabel()
        optionLabel.font = UIFont._16SemiboldFont
        optionLabel.backgroundColor = .clear
        
        containerView.addSubview(optionLabel)
        
        numberLabel = UILabel()
        numberLabel.font = ._16MediumFont
        numberLabel.backgroundColor = .clear
        numberLabel.text = "0"
        numberLabel.textColor = .clickerMediumGray
        containerView.addSubview(numberLabel)
        
        highlightView = UIView()
        highlightView.layer.cornerRadius = 8
        if #available(iOS 11.0, *) {
            highlightView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
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
        
        optionLabel.snp.updateConstraints { make in
            make.left.equalToSuperview().offset(15.5)
            make.right.equalTo(numberLabel.snp.left)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        numberLabel.snp.updateConstraints { make in
            make.height.equalTo(optionLabel.snp.height)
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
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
