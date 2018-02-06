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
    
    var plusLabel: UILabel!
    var addMoreLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clickerBackground
        layer.cornerRadius = 8
        layer.borderColor = UIColor.clickerBorder.cgColor
        layer.borderWidth = 0.5
        
        setupViews()
        layoutSubviews()
    }
    
    func setupViews() {
        plusLabel = UILabel()
        plusLabel.text = "+"
        plusLabel.textColor = .clickerDarkGray
        plusLabel.textAlignment = .center
        plusLabel.font = UIFont.systemFont(ofSize: 20.5, weight: .semibold)
        addSubview(plusLabel)
        
        addMoreLabel = UILabel()
        addMoreLabel.text = "Add More"
        addMoreLabel.textColor = UIColor(red: 209/255, green: 212/255, blue: 223/255, alpha: 1.0)
        addMoreLabel.font = UIFont.systemFont(ofSize: 16)
        addSubview(addMoreLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        plusLabel.snp.updateConstraints { make in
            make.size.equalTo(CGSize(width: frame.width * 0.1268436578, height: frame.height))
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        addMoreLabel.snp.updateConstraints { make in
            make.left.equalTo(plusLabel.snp.right)
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
