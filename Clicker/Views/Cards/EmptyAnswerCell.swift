//
//  EmptyAnswerCard.swift
//  Clicker
//
//  Created by eoin on 4/17/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class EmptyAnswerCell: UICollectionViewCell {
    
    var monkeyView: UIImageView!
    var waitingLabel: UILabel!
    var nothingToSeeLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    
    func setupViews() {
        monkeyView = UIImageView(image: #imageLiteral(resourceName: "monkey_emoji"))
        addSubview(monkeyView)
        
        nothingToSeeLabel = UILabel()
        nothingToSeeLabel.text = "Nothing to see yet."
        nothingToSeeLabel.font = ._16SemiboldFont
        nothingToSeeLabel.textColor = .clickerBorder
        nothingToSeeLabel.textAlignment = .center
        addSubview(nothingToSeeLabel)
        
        waitingLabel = UILabel()
        waitingLabel.text = "Waiting for the host to post a poll"
        waitingLabel.font = ._14MediumFont
        waitingLabel.textColor = .clickerMediumGray
        waitingLabel.textAlignment = .center
        addSubview(waitingLabel)
        
    }
    
    func setupConstraints() {
        nothingToSeeLabel.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(19)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        monkeyView.snp.makeConstraints { make in
            make.width.equalTo(31)
            make.height.equalTo(34)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nothingToSeeLabel).offset(-25)
        }
        
        waitingLabel.snp.makeConstraints { make in
            make.width.equalTo(220)
            make.height.equalTo(17)
            make.centerX.equalToSuperview()
            make.top.equalTo(nothingToSeeLabel.snp.bottom).offset(11)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
