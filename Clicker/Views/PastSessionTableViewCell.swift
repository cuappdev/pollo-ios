//
//  PastSessionTableViewCell.swift
//  Clicker
//
//  Created by Keivan Shahida on 10/15/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class PastSessionTableViewCell: UITableViewCell {
    
    var sessionLabel = UILabel()
    var dateLabel = UILabel()
    var bottomBorder = CALayer()
    var course: Course?
    
    // MARK: - INITIALIZATION
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
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
        if let name = course?.name, let term = course?.term {
            sessionLabel.text = "\(name) - \(term)"
        }
        sessionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        sessionLabel.textAlignment = NSTextAlignment.left
        sessionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel = UILabel(frame: .zero)
        dateLabel.clipsToBounds = false
        dateLabel.textColor = .gray
        dateLabel.text = "Last session two days ago" //TEMP
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        dateLabel.textAlignment = NSTextAlignment.left
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: 80.0, width: Constants.Screen.width, height: 0.5)
        bottomBorder.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0).cgColor
        
        contentView.addSubview(sessionLabel)
        contentView.addSubview(dateLabel)
        contentView.layer.addSublayer(bottomBorder)
        
        setConstraints()
    }
    
    func setConstraints() {
        sessionLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(18)
            make.top.equalToSuperview().offset(18)
        }
        
        dateLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(18)
            make.top.equalToSuperview().offset(44.5)
        }
    }
}
