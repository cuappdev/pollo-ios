//
//  LiveSessionTableViewCell.swift
//  Clicker
//
//  Created by Keivan Shahida on 10/15/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class LiveSessionTableViewCell: UITableViewCell {
    

    var sessionLabel: UILabel!
    var wifiImageView: UIImageView!
    
    var sessionText: String! {
        didSet {
            sessionLabel.text = sessionText
        }
    }
    
    // MARK: - INITIALIZATION
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        layoutSubviews()
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
        sessionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        contentView.addSubview(sessionLabel)
        
        wifiImageView = UIImageView()
        wifiImageView.image = UIImage(named: "wifi")?.withRenderingMode(.alwaysTemplate)
        wifiImageView.tintColor = .green
        wifiImageView.contentMode = .scaleAspectFit
        contentView.addSubview(wifiImageView)
        
        setConstraints()
    }
    
    // MARK: - CONSTRAINTS
    func setConstraints() {
        sessionLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(56.5)
        }
        
        wifiImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(25)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
    }
}
