//
//  AnswerButton.swift
//  Clicker
//
//  Created by Keivan Shahida on 11/5/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

class AnswerButton: UIButton {

    init(frame: CGRect, description: String) {
        super.init(frame: frame)
        
        titleEdgeInsets = UIEdgeInsetsMake(18, 43, 18, 18)
        setTitle("\(description)", for: .normal)
        setTitleColor(.black, for: .normal)
        layer.borderWidth = 1
        layer.borderColor = UIColor.clickerBorder.cgColor
        contentHorizontalAlignment = .left
        backgroundColor = .white
        layer.cornerRadius = 8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
