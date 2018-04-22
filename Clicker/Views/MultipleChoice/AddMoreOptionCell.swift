//
//  AddMoreOptionCell.swift
//  Clicker
//
//  Created by Kevin Chan on 2/6/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class AddMoreOptionCell: UITableViewCell {
    
    let edgePadding: CGFloat = 18
    let bottomPadding: CGFloat = 6
    
    var plusLabel: UILabel!
    var addMoreLabel: UILabel!
    
    // MARK: - INITIALIZATION
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.layer.cornerRadius = 5
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.clickerBorder.cgColor
        
        setupViews()
        layoutSubviews()
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        plusLabel = UILabel()
        plusLabel.text = "+"
        plusLabel.textColor = .clickerMediumGray
        plusLabel.textAlignment = .center
        plusLabel.font = ._20MediumFont
        addSubview(plusLabel)
        
        addMoreLabel = UILabel()
        addMoreLabel.text = "Add Option"
        addMoreLabel.textColor = .clickerMediumGray
        addMoreLabel.font = ._16RegularFont
        addSubview(addMoreLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 0, bottomPadding, 0))
        
        plusLabel.snp.updateConstraints { make in
            make.size.equalTo(CGSize(width: 13, height: frame.height - bottomPadding))
            make.left.equalToSuperview().offset(edgePadding)
            make.top.equalToSuperview()
        }
        
        addMoreLabel.snp.updateConstraints { make in
            make.left.equalTo(plusLabel.snp.right).offset(6.5)
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-bottomPadding)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
