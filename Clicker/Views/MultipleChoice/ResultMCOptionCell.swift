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
    
    var containerView: UIView!
    var choiceLabel = UILabel()
    var choiceTag: Int! {
        didSet {
            choiceLabel.text = intToMCOption(choiceTag)
        }
    }
    var optionLabel = UILabel()
    var numberLabel = UILabel()
    var emptyView: UIView!
    var highlightView: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupViews()
        layoutSubviews()
    }
    
    func setupViews() {
        containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
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
        numberLabel.text = "3"
        containerView.addSubview(numberLabel)
        
        highlightView = UIView()
        highlightView.backgroundColor = .clickerLightBlue
        containerView.addSubview(highlightView)
        containerView.sendSubview(toBack: highlightView)
        
        emptyView = UIView()
        emptyView.backgroundColor = .clickerBackground
        addSubview(emptyView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.snp.updateConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(frame.height - 5)
        }
        
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
//            if let per = percent {
//                make.width.equalToSuperview().multipliedBy(per)
//            } else {
//                make.width.equalToSuperview()
//            }
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        emptyView.snp.updateConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(5)
            make.width.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
