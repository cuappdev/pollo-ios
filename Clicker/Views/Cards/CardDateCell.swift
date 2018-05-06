//
//  CardDateCell.swift
//  Clicker
//
//  Created by Kevin Chan on 5/4/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class CardDateCell: UICollectionViewCell, CardDelegate {
    
    var userRole: UserRole!
    var cardType: CardType!
    var poll: Poll!
    
    var dateLabel: UILabel!
    var shadowImage: UIImageView!
    var cardView: CardView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        dateLabel = UILabel()
        dateLabel.textColor = .clickerMediumGray
        dateLabel.font = ._14BoldFont
        dateLabel.textAlignment = .center
        addSubview(dateLabel)
        
        shadowImage = UIImageView(image: #imageLiteral(resourceName: "cardShadow"))
        addSubview(shadowImage)
        
        cardView = CardView(frame: .zero, userRole: userRole, cardDelegate: self)
        cardView.highlightColor = .clickerHalfGreen
        addSubview(cardView)
    }
    
    func setupConstraints() {
        
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        cardView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.left.equalToSuperview()
            make.right.equalToSuperview().inset(13)
            make.height.equalTo(398)
        }
        
        shadowImage.snp.makeConstraints { make in
            make.width.equalTo(13)
            make.height.equalTo(cardView.snp.height).multipliedBy(0.94)
            make.centerY.equalTo(cardView.snp.centerY)
            make.right.equalToSuperview()
        }
    }
    
    // MARK: Configure after variables are set
    func configure() {
        cardView.questionLabel.text = poll.text
        cardView.poll = poll
        cardView.cardType = cardType
        cardView.setupCard()
    }
    
    // MARK: CARD DELEGATE
    func questionBtnPressed() { }
    
    func emitTally(answer: [String : Any]) { }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
