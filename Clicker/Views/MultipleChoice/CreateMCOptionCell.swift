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
    func updatedTextField(index: Int, text: String)
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
    
    //MARK: - INITIALIZATION
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clickerBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.clickerBorder.cgColor
        contentView.layer.borderWidth = 0.5
        contentView.backgroundColor = .white
        
        setupViews()
        layoutSubviews()
    }
    
    //MARK: - LAYOUT
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
        addOptionTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        addOptionTextField.delegate = self
        addSubview(addOptionTextField)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 0, 5, 0))
        
        choiceLabel.snp.updateConstraints { make in
            make.size.equalTo(CGSize(width: frame.width * 0.12, height: 21.5))
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        trashButton.snp.updateConstraints { make in
            make.size.equalTo(choiceLabel.snp.size)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        addOptionTextField.snp.updateConstraints { make in
            make.left.equalTo(choiceLabel.snp.right)
            make.right.equalTo(trashButton.snp.left)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - MultipleChoiceOptionDelegate
    @objc func deleteOption(){
        mcOptionDelegate.deleteOption(index: choiceTag)
    }
    
    @objc func textFieldDidChange() {
        if let text = addOptionTextField.text {
            mcOptionDelegate.updatedTextField(index: choiceTag, text: text)
        }
    }
    
    // MARK: - KEYBOARD
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
