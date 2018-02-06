//
//  CreateMultipleChoiceOptionCell.swift
//  Clicker
//
//  Created by Kevin Chan on 2/6/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class CreateMultipleChoiceOptionCell: UITableViewCell {

    var choiceLabel = UILabel()
    var choiceTag: Int! {
        didSet {
            choiceLabel.text = String(Character(UnicodeScalar(choiceTag + Int(("A" as UnicodeScalar).value))!))
        }
    }
    var addOptionTextField: UITextField!
    var trashButton: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.borderColor = UIColor.clickerBorder.cgColor
        layer.borderWidth = 0.5
        
        setupViews()
        layoutSubviews()
    }
    
    func setupViews() {
        choiceLabel.textColor = .clickerDarkGray
        choiceLabel.font = UIFont._16SemiboldFont
        choiceLabel.textAlignment = .center
        addSubview(choiceLabel)
        
        trashButton = UIButton()
        trashButton.setImage(#imageLiteral(resourceName: "trash"), for: .normal)
        trashButton.backgroundColor = .clear
        addSubview(trashButton)
        
        addOptionTextField = UITextField()
        addOptionTextField.placeholder = "Add Option"
        addOptionTextField.font = UIFont._16SemiboldFont
        addOptionTextField.borderStyle = .none
        addSubview(addOptionTextField)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        choiceLabel.snp.updateConstraints { make in
            make.size.equalTo(CGSize(width: frame.width * 0.1268436578, height: frame.height))
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        trashButton.snp.updateConstraints { make in
            make.size.equalTo(choiceLabel.snp.size)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        addOptionTextField.snp.updateConstraints { make in
            make.left.equalTo(choiceLabel.snp.right)
            make.right.equalTo(trashButton.snp.left)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
