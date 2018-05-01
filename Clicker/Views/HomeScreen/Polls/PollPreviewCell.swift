//
//  PollPreviewCell.swift
//  Clicker
//
//  Created by eoin on 4/16/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class PollPreviewCell: UITableViewCell {
    
    var session: Session!
    
    var nameLabel: UILabel!
    var timeLabel: UILabel!
    var line: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    // MARK - layout
    
    func setupViews() {
        nameLabel = UILabel()
        nameLabel.font = ._18SemiboldFont
        addSubview(nameLabel)
    
        timeLabel = UILabel()
        timeLabel.font = ._18MediumFont
        timeLabel.textColor = .clickerMediumGray
        addSubview(timeLabel)
        
        line = UIView()
        line.backgroundColor = .clickerBorder
        addSubview(line)
    }
    
    func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(19.5)
            make.height.equalTo(21.5)
            make.width.equalTo(300)
            make.left.equalToSuperview().offset(17)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.height.equalTo(17)
            make.left.equalTo(nameLabel.snp.left)
            make.width.equalTo(nameLabel.snp.width)
        }
        
        line.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.equalToSuperview().offset(18)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    func updateLabels() {
        nameLabel.text = session.name
        if let live = session.isLive {
            if live {
                timeLabel.text = "This poll is live!"
            } else {
                timeLabel.text = "Not currently active"
            }
        } else {
            timeLabel.text = "Not currently active"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
