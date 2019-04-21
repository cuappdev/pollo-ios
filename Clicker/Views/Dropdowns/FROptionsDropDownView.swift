//
//  FROptionsDropDownView.swift
//  Clicker
//
//  Created by eoin on 5/4/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class FROptionsDropDownView: UIView {
    
    var responsesButton: UIButton!
    var responsesCheck: UIImageView!
    var responsesLabel: UILabel!
    var shareResponses: Bool = false
    
    var shareVotes: Bool = false
    var votesButton: UIButton!
    var votesCheck: UIImageView!
    var votesLabel: UILabel!
    
    let checkImage = UIImage(named: "blueCheck")
    let circleImage = UIImage(named: "emptyCircle")
    
    var line: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        shareVotes = false
        shareResponses = false
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        backgroundColor = .clickerWhite
        
        responsesLabel = UILabel()
        responsesLabel.textColor = .clickerBlack0
        responsesLabel.font = ._14MediumFont
        responsesLabel.text = "Show responses to audience"
        responsesLabel.textAlignment = .left
        addSubview(responsesLabel)
        
        responsesCheck = UIImageView(image: circleImage)
        addSubview(responsesCheck)
        
        responsesButton = UIButton()
        responsesButton.addTarget(self, action: #selector(toggleResponses), for: .touchUpInside)
        addSubview(responsesButton)

        votesLabel = UILabel()
        votesLabel.textColor = .clickerGrey2
        votesLabel.text = "Show vote count to audience"
        votesLabel.font = ._14MediumFont
        votesLabel.textAlignment = .left
        addSubview(votesLabel)
        
        votesCheck = UIImageView(image: circleImage)
        addSubview(votesCheck)
        
        votesButton = UIButton()
        votesLabel.isEnabled = false
        votesButton.addTarget(self, action: #selector(toggleVotes), for: .touchUpInside)
        addSubview(votesButton)
        
        line = UIView()
        line.backgroundColor = .clickerGrey5
        addSubview(line)
    }
    func setupConstraints() {
        responsesButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
            make.centerY.equalToSuperview().multipliedBy(0.5)
        }
        
        responsesLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalTo(responsesButton.snp.centerY)
            make.width.equalTo(190)
            make.height.equalTo(17)
        }
        
        responsesCheck.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(24)
            make.centerY.equalTo(responsesButton.snp.centerY)
            make.right.equalToSuperview().inset(19)
        }
        
        votesButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
            make.centerY.equalToSuperview().multipliedBy(1.5)
        }
        
        votesLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.centerY.equalTo(votesButton.snp.centerY)
            make.width.equalTo(200)
            make.height.equalTo(17)
        }
        
        votesCheck.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(24)
            make.centerY.equalTo(votesButton.snp.centerY)
            make.right.equalToSuperview().inset(19)
        }
        
        line.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    @objc func toggleResponses() {
        if !shareResponses {
            votesButton.isEnabled = true
            votesLabel.textColor = .clickerBlack0

            responsesCheck.image = checkImage
        } else {
            votesButton.isEnabled = false
            votesLabel.textColor = .clickerGrey2
            
            responsesCheck.image = circleImage
            votesCheck.image = circleImage
            shareVotes = false
        }
        shareResponses = !shareResponses
    }
    
    @objc func toggleVotes() {
        if !shareVotes {
            votesCheck.image = checkImage
        } else {
            votesCheck.image = circleImage
        }
        shareVotes = !shareVotes
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
