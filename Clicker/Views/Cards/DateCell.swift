//
//  DateCell.swift
//  Clicker
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import SnapKit
import UIKit

class DateCell: UICollectionViewCell {
    
    var dateLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        dateLabel.textColor = .clickerGrey2
        dateLabel.textAlignment = .center
        contentView.addSubview(dateLabel)
    }
    
    func configure(with date: String) {
        dateLabel.text = date
    }
    
    override func updateConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        super.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
