//
//  LiveSessionTableViewCell.swift
//  Clicker
//
//  Created by Keivan Shahida on 10/13/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class LiveSessionTableViewCell: UITableViewCell {
    
    var sessionLabel = UILabel()
    
    // MARK: - INITIALIZATION
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LAYOUT
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        sessionLabel = UILabel(frame: .zero)
        sessionLabel.clipsToBounds = false
        sessionLabel.textColor = .black
        sessionLabel.text = "ASTRO 1101 - Lecture 8" //TEMP
        sessionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        contentView.addSubview(sessionLabel)
        setConstraints()
    }
    func setConstraints() {
        sessionLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(56.5)
        }
    }
}
