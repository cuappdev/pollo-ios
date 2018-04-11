//
//  NewGroupHeader.swift
//  Clicker
//
//  Created by Kevin Chan on 4/11/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation
import UIKit

class NewGroupHeader: UITableViewHeaderFooterView {
    
    var newGroupButton: UIButton!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupViews()
        layoutSubviews()
    }
    
    func setupViews() {
        newGroupButton = UIButton(type: .system)
        newGroupButton.setTitle("+ New Group", for: .normal)
        newGroupButton.titleLabel?.font = UIFont._16RegularFont
        addSubview(newGroupButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newGroupButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(100)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
