//
//  CreateMCOptionCell.swift
//  Clicker
//
//  Created by Kevin Chan on 2/22/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

protocol MultipleChoiceOptionDelegate {
    func deleteOption(index: Int)
}

class CreateMCOptionCell: UITableViewCell, UITextFieldDelegate {
    
    var mcOptionDelegate: MultipleChoiceOptionDelegate!
    
    var choiceLabel = UILabel()
    var choiceTag: Int! {
        didSet {
            choiceLabel.text = intToMCOption(choiceTag)
        }
    }
    var addOptionTextField: UITextField!
    var trashButton: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.clickerBorder.cgColor
        contentView.layer.borderWidth = 0.5
        
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
        trashButton.addTarget(self, action: #selector(deleteOption), for: .touchUpInside)
        addSubview(trashButton)
        
        addOptionTextField = UITextField()
        addOptionTextField.placeholder = "Add Option"
        addOptionTextField.font = UIFont._16SemiboldFont
        addOptionTextField.borderStyle = .none
        addOptionTextField.returnKeyType = UIReturnKeyType.done
        addOptionTextField.delegate = self
        addSubview(addOptionTextField)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 0, 5, 0))
        
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
    
    @objc func deleteOption(){
        print("delete cell \(choiceTag)")
        mcOptionDelegate.deleteOption(index: choiceTag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
}
