//
//  NoResponsesCell.swift
//  Pollo
//
//  Created by Matthew Coufal on 10/20/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class NoResponsesCell: UICollectionViewCell {
    
    // MARK: - View vars
    var noResponsesLabel: UILabel!
    
    // MARK: - Constants
    let noResponsesText: String = "No responses yet"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        noResponsesLabel = UILabel()
        noResponsesLabel.text = noResponsesText
        noResponsesLabel.textColor = .blueyGrey
        noResponsesLabel.font = ._12MediumFont
        noResponsesLabel.textAlignment = .center
        contentView.addSubview(noResponsesLabel)
        
        noResponsesLabel.snp.makeConstraints { make in
            make.center.width.equalToSuperview()
            make.height.equalTo(0)
        }
        
    }
    
    func configure(with space: CGFloat) {
        noResponsesLabel.snp.updateConstraints { update in
            update.height.equalTo(space)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
