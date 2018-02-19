//
//  LiveSessionCell.swift
//  Clicker
//
//  Created by Keivan Shahida on 2/19/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class LiveSessionCell: UITableViewCell {
    
    // MARK: - INITIALIZATION
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
    }
    
    // MARK: - LAYOUT
    override open func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
