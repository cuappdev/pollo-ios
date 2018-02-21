//
//  ResultMCOptionCell.swift
//  Clicker
//
//  Created by Keivan Shahida on 2/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit


class ResultMCOptionCell: UITableViewCell {
    
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
    
//    var width: CGFloat! = 0 {
//        didSet {
//            layoutSubviews()
//        }
//    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clickerBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.clickerBorder.cgColor
        contentView.layer.borderWidth = 0.5
        
        setupViews()
        layoutSubviews()
    }
    
    func setupViews() {
        choiceLabel.textColor = .clickerDarkGray
        choiceLabel.font = UIFont._16SemiboldFont
        choiceLabel.textAlignment = .center
        addSubview(choiceLabel)
        
        optionLabel.font = UIFont._16SemiboldFont
        optionLabel.backgroundColor = .clear
        addSubview(optionLabel)
        
        numberLabel.font = ._16RegularFont
        numberLabel.backgroundColor = .clear
        numberLabel.text = "3"
        addSubview(numberLabel)
        
        highlightView = UIView()
        highlightView.backgroundColor = .clickerLightBlue
        addSubview(highlightView)
        sendSubview(toBack: highlightView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 0, 5, 0))
        
        choiceLabel.snp.updateConstraints { make in
            make.width.equalTo(frame.width * 0.1268436578)
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
            make.bottom.equalToSuperview().offset(-5)
            make.left.equalToSuperview()
            self.highlightWidthConstraint = make.width.equalTo(0).constraint
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
