//
//  NoResponsesCell.swift
//  Clicker
//
//  Created by Matthew Coufal on 10/20/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class NoResponsesCell: UICollectionViewCell {
    
    // MARK: - Data vars
    var space: CGFloat!
    
    // MARK: - View vars
    var noResponsesLabel: UILabel!
    
    // MARK: - Constants
    let noResponsesText: String = "No responses yet"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        noResponsesLabel = UILabel()
        noResponsesLabel.text = noResponsesText
        noResponsesLabel.textColor = .clickerGrey2
        noResponsesLabel.font = ._12MediumFont
        noResponsesLabel.textAlignment = .center
        contentView.addSubview(noResponsesLabel)
        
    }
    
    override func updateConstraints() {
        
        noResponsesLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(space)
            make.center.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    func configure(with space: CGFloat) {
        self.space = space
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
