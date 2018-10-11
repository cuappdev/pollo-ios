//
//  CreateMCOptionCell.swift
//  Clicker
//
//  Created by Kevin Chan on 2/22/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

protocol CreateMCOptionCellDelegate {
    func createMCOptionCellDidUpdateTextField(index: Int, text: String)
    func createMCOptionCellDidDeleteOption(index: Int)
}

class CreateMCOptionCell: UICollectionViewCell, UITextFieldDelegate {
    
    // MARK: Layout constants
    let trashIconHeight: CGFloat = 21.5
    let edgePadding: CGFloat = 18
    let bottomPadding: CGFloat = 6
    
    // MARK: Views
    var addOptionTextField: UITextField!
    var trashButton: UIButton!
    
    // MARK: Data
    var delegate: CreateMCOptionCellDelegate!
    var index: Int!
    
    // MARK: - INITIALIZATION
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        setupViews()
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        
        addOptionTextField = UITextField()
        addOptionTextField.font = UIFont._16RegularFont
        addOptionTextField.layer.cornerRadius = 5
        addOptionTextField.borderStyle = .none
        addOptionTextField.backgroundColor = .clickerGrey6
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
        
        contentView.addSubview(addOptionTextField)
    }
    
    override func updateConstraints() {
        addOptionTextField.snp.updateConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(bottomPadding)
        }
        
        trashButton.snp.updateConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(trashIconHeight)
            make.height.equalTo(trashIconHeight)
        }
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(for mcOptionModel: PollBuilderMCOptionModel, delegate: CreateMCOptionCellDelegate) {
        self.delegate = delegate
        trashButton.isHidden = mcOptionModel.totalOptions <= 2
        switch mcOptionModel.type {
        case .newOption(option: let option, index: let index):
            self.index = index
            let choiceTag = intToMCOption(index)
            addOptionTextField.attributedPlaceholder = NSAttributedString(string: "Option \(choiceTag)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.clickerGrey2, NSAttributedStringKey.font: UIFont._16RegularFont])
            addOptionTextField.text = option
        default:
            return
        }
    }
    
    @objc func deleteOption(){
        delegate.createMCOptionCellDidDeleteOption(index: index)
    }
    
    @objc func textFieldDidChange() {
        if let text = addOptionTextField.text {
            delegate.createMCOptionCellDidUpdateTextField(index: index, text: text)
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
    
    func shouldFocusTextField() {
        guard let field = addOptionTextField else {
            print("cannot focus nil text field, something went wrong")
            return
        }
        field.becomeFirstResponder()
    }
}
