//
//  EmptyPastSessionTableViewCell.swift
//  Clicker
//
//  Created by Keivan Shahida on 11/29/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

class EmptyPastSessionTableViewCell: UITableViewCell {

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
        
        setConstraints()
    }
    
    func setConstraints() {
        
    }
}
