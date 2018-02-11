//
//  MultipleChoiceOptionView.swift
//  Clicker
//
//  Created by Kevin Chan on 2/5/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class MultipleChoiceOptionView: UIView {
    
    var optionTag: Int!
    var optionLabel: UILabel!
    var optionTextField: UITextField!
    
    init(frame: CGRect, optionTag: Int) {
        super.init(frame: frame)
        self.optionTag = optionTag
        
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.borderColor = UIColor.clickerBorder.cgColor
        layer.borderWidth = 0.5
        
        optionLabel = UILabel()
        optionLabel.text = String(Character(UnicodeScalar(optionTag + Int(("A" as UnicodeScalar).value))!))
        optionLabel.textColor = .clickerDarkGray
        optionLabel.font = UIFont._16SemiboldFont
        optionLabel.textAlignment = .center
        addSubview(optionLabel)
        
        optionTextField = UITextField()
        optionTextField.placeholder = "Add Option"
        optionTextField.font = UIFont._16RegularFont
        optionTextField.borderStyle = .none
        addSubview(optionTextField)
        
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        optionLabel.snp.updateConstraints { make in
            make.size.equalTo(CGSize(width: frame.width * 0.1268436578, height: frame.height))
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        optionTextField.snp.updateConstraints { make in
            make.left.equalTo(optionLabel.snp.right)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
