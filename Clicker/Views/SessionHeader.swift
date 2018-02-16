//
//  SessionHeader.swift
//  Clicker
//
//  Created by Kevin Chan on 2/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class SessionHeader: UITableViewHeaderFooterView {
    
    var headerLabel: UILabel!
    
    // MARK: - INITIALIZATION
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        
        headerLabel = UILabel()
        headerLabel.text = "Saved Sessions"
        headerLabel.font = UIFont._16SemiboldFont
        headerLabel.textColor = UIColor.clickerMediumGray
        addSubview(headerLabel)
        
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        headerLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

