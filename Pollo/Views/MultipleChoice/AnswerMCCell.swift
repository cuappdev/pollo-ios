//
//  AnswerMCCell.swift
//  Pollo
//
//  Created by Kevin Chan on 2/22/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class AnswerMCCell: UITableViewCell {
    
    var option: String!
    
    var choiceLabel = UILabel()
    var choiceTag: Int! {
        didSet {
            choiceLabel.text = String(Character(UnicodeScalar(choiceTag + Int(("A" as UnicodeScalar).value))!))
        }
    }
    
    var optionLabel = UILabel()
    
    // MARK: - INITIALIZATION
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clickerGrey4
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.clickerGrey5.cgColor
        contentView.layer.borderWidth = 0.5
        contentView.backgroundColor = .white
        
        setupViews()
        layoutSubviews()
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        choiceLabel.textColor = .clickerGrey3
        choiceLabel.font = ._16SemiboldFont
        choiceLabel.textAlignment = .center
        addSubview(choiceLabel)
        
        optionLabel.font = ._16RegularFont
        optionLabel.backgroundColor = .clear
        addSubview(optionLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 18, bottom: 5, right: 18))
        
        choiceLabel.snp.updateConstraints { make in
            make.size.equalTo(CGSize(width: frame.width * 0.13, height: frame.height))
            make.left.equalToSuperview().offset(18)
            make.top.equalToSuperview()
        }
        
        optionLabel.snp.updateConstraints { make in
            make.left.equalTo(choiceLabel.snp.right).offset(14)
            make.right.equalToSuperview().offset(-14)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            contentView.layer.borderColor = UIColor.clickerBlue.cgColor
            contentView.layer.borderWidth = 2.0
        } else {
            contentView.layer.borderColor = UIColor.clickerGrey5.cgColor
            contentView.layer.borderWidth = 0.5
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            contentView.layer.borderColor = UIColor.clickerBlue.cgColor
            contentView.layer.borderWidth = 2.0
        } else {
            contentView.layer.borderColor = UIColor.clickerGrey5.cgColor
            contentView.layer.borderWidth = 0.5
        }
    }
}
