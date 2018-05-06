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
    
    var shadowImage: UIImageView!
    var cardView: CardView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        shadowImage = UIImageView(image: #imageLiteral(resourceName: "cardShadow"))
        addSubview(shadowImage)
        
        cardView = CardView(frame: .zero, userRole: userRole, cardDelegate: self)
        addSubview(cardView)
    }
    
    func setupConstraints() {
        
    }
    
    // MARK: CARD DELEGATE
    func questionBtnPressed() { }
    
    func emitTally(answer: [String : Any]) { }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
