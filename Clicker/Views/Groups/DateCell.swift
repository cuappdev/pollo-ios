//
//  DateCell.swift
//  Clicker
//
//  Created by eoin on 3/18/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class DateCell: UICollectionViewCell {
    
    var dateLabel: UILabel!
    var lineView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        layoutSubviews()
    }
    
    func setupViews() {
        dateLabel = UILabel()
        dateLabel.text = "March 18th"
        dateLabel.font = ._14MediumFont
        dateLabel.textColor = .clickerMediumGray
        addSubview(dateLabel)
        
        lineView = UIView()
        lineView.backgroundColor = .clickerBorder
        addSubview(lineView)
    }
    
    override func layoutSubviews() {
        dateLabel.snp.updateConstraints{ make in
            make.left.equalToSuperview().offset(18)
            make.top.equalToSuperview().offset(46)
            make.width.equalTo(150)
            make.height.equalTo(17)
        }
        
        lineView.snp.updateConstraints{ make in
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
            make.left.equalTo(dateLabel.snp.left)
            make.right.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
