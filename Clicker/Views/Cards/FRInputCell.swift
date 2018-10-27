//
//  FRInputCell.swift
//  Clicker
//
//  Created by Kevin Chan on 9/10/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol FRInputCellDelegate {
    
    func frInputCellSubmittedResponse(response: String)
    
}

class FRInputCell: UICollectionViewCell {
    
    // MARK: - View vars
    var inputTextField: UITextField!
    
    // MARK: - Data vars
    var delegate: FRInputCellDelegate!
    
    // MARK: - Constants
    let textFieldBorderWidth: CGFloat = 1
    let textFieldTextInset: CGFloat = 18
    let textFieldHorizontalPadding: CGFloat = 16.5
    let textFieldHeight: CGFloat = 47
    let textFieldVerticalPadding: CGFloat = 8.5
    let textFieldPlaceholder = "Type a response"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clickerWhite
        setupViews()
    }
    
    // MARK: - Layout
    func setupViews() {
        inputTextField = UITextField()
        inputTextField.layer.cornerRadius = textFieldHeight / 2.0
        inputTextField.layer.borderWidth = textFieldBorderWidth
        inputTextField.layer.borderColor = UIColor.clickerGrey5.cgColor
        inputTextField.font = ._16MediumFont
        inputTextField.layer.sublayerTransform = CATransform3DMakeTranslation(textFieldTextInset, 0, 0)
        inputTextField.placeholder = textFieldPlaceholder
        inputTextField.returnKeyType = .send
        inputTextField.delegate = self
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: textFieldTextInset * 2, height: textFieldHeight))
        inputTextField.rightView = rightView
        inputTextField.rightViewMode = .always
        contentView.addSubview(inputTextField)
    }
    
    override func updateConstraints() {
        inputTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(textFieldHorizontalPadding)
            make.trailing.equalToSuperview().inset(textFieldHorizontalPadding)
            make.height.equalTo(textFieldHeight)
            make.centerY.equalToSuperview()
        }
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(with delegate: FRInputCellDelegate) {
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FRInputCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            delegate.frInputCellSubmittedResponse(response: text)
            textField.text = ""
        }
        endEditing(true)
        return false
    }
    
}
