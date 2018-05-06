//
//  ResultFRCell.swift
//  Clicker
//
//  Created by Kevin Chan on 3/17/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class ResultFRCell: UITableViewCell {
    
    var response: String!
    var count: Int!
    var freeResponseLabel: UILabel!
    var countLabel: UILabel!
    
    //MARK: - INITIALIZATION
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        clipsToBounds = true
        
        setupViews()
        setupConstraints()
    }
    
    //MARK: - LAYOUT
    func setupViews() {
        freeResponseLabel = UILabel()
        freeResponseLabel.font = UIFont._16RegularFont
        freeResponseLabel.backgroundColor = .white
        freeResponseLabel.lineBreakMode = .byWordWrapping
        freeResponseLabel.numberOfLines = 0
        addSubview(freeResponseLabel)
        
        countLabel = UILabel()
        countLabel.font = ._12SemiboldFont
        countLabel.textColor = .clickerBlue
        countLabel.textAlignment = .center
        addSubview(countLabel)
    }
    
    func setupConstraints() {
        freeResponseLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(13)
        }
    }
    
    func configure() {
        freeResponseLabel.text = response
        countLabel.text = "\(count)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
