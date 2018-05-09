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
    
    let trashIconHeight: CGFloat = 21.5
    let edgePadding: CGFloat = 18
    let bottomPadding: CGFloat = 6
    
    var mcOptionDelegate: MultipleChoiceOptionDelegate!
    var mcOption: String!
    var choiceTag: Int! {
        didSet {
            mcOption = intToMCOption(choiceTag)
        }
    }
    var addOptionTextField: UITextField!
    var trashButton: UIButton!
    
    // MARK: - INITIALIZATION
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        setupViews()
        layoutSubviews()
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        
        addOptionTextField = UITextField()
        addOptionTextField.attributedPlaceholder = NSAttributedString(string: "Add Option", attributes: [NSAttributedStringKey.foregroundColor: UIColor.clickerMediumGrey, NSAttributedStringKey.font: UIFont._16RegularFont])
        addOptionTextField.font = UIFont._16RegularFont
        addOptionTextField.layer.cornerRadius = 5
        addOptionTextField.borderStyle = .none
        addOptionTextField.backgroundColor = .clickerOptionGrey
        addOptionTextField.returnKeyType = .done
        addOptionTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        addOptionTextField.delegate = self
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: edgePadding, height: contentView.frame.height))
        addOptionTextField.leftView = leftPaddingView
        addOptionTextField.leftViewMode = .always
        
        trashButton = UIButton()
        trashButton.setImage(#imageLiteral(resourceName: "TrashIcon"), for: .normal)
        trashButton.addTarget(self, action: #selector(deleteOption), for: .touchUpInside)
        
        let rightTrashView = UIView(frame: CGRect(x: 0, y: 0, width: trashIconHeight + 13, height: contentView.frame.height))
        addOptionTextField.rightView = rightTrashView
        addOptionTextField.rightViewMode = .always
        rightTrashView.addSubview(trashButton)
        
        addSubview(addOptionTextField)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addOptionTextField.snp.updateConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-bottomPadding)
        }
        
        trashButton.snp.updateConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(trashIconHeight)
            make.height.equalTo(trashIconHeight)
        }

    }
    
    // MARK: - MC OPTION DELEGATE
    
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
