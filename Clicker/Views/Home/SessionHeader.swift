//
//  SavedSessionHeader.swift
//  Clicker
//
//  Created by Kevin Chan on 2/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class SessionHeader: UITableViewHeaderFooterView {
    
    var headerLabel: UILabel!
    var title: String! {
        didSet {
            headerLabel.text = title
        }
    }
    
    // MARK: - INITIALIZATION
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        layer.backgroundColor = UIColor.clear.cgColor
        
        headerLabel = UILabel()
        headerLabel.font = UIFont._16SemiboldFont
        headerLabel.textColor = UIColor.clickerMediumGray
        addSubview(headerLabel)
        
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        headerLabel.snp.makeConstraints { make in
            make.height.equalTo(19)
            make.left.equalToSuperview().offset(18)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
