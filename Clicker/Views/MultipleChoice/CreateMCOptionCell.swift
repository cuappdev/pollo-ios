//
//  CreateMCOptionCell.swift
//  Clicker
//
//  Created by Kevin Chan on 2/22/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

protocol CreateMCOptionCellDelegate: class {

    func createMCOptionCellDidUpdateTextField(index: Int, text: String, isCorrect: Bool)
    func createMCOptionCellDidUpdateIsCorrect(index: Int, text: String, isCorrect: Bool)
    func createMCOptionCellDidDeleteOption(index: Int)

}

class CreateMCOptionCell: UICollectionViewCell, UITextFieldDelegate {

    // MARK: Views
    var containerView: UIView!
    var isCorrectButton: UIButton!
    var addOptionTextField: UITextField!
    var trashButton: UIButton!
    var unfilledCircleImage: UIImage!
    var filledCircleImage: UIImage!
    
    // MARK: Data
    weak var delegate: CreateMCOptionCellDelegate?
    var index: Int!
    var isCorrect: Bool = false

    // MARK: - Constants
    let isCorrectButtonLeftPadding: CGFloat = 12
    let isCorrectButtonLength: CGFloat = 23
    let addOptionTextFieldLeftPadding: CGFloat = 8
    let trashIconHeight: CGFloat = 21.5
    let edgePadding: CGFloat = 18
    let bottomPadding: CGFloat = 6
    let unfilledCircleImageName = "greyEmptyCircle"
    let filledCircleImageName = "option_filled"
    
    // MARK: - INITIALIZATION
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        setupViews()
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        containerView = UIView()
        containerView.backgroundColor = .clickerGrey6
        containerView.layer.cornerRadius = 5
        contentView.addSubview(containerView)

        unfilledCircleImage = UIImage(named: unfilledCircleImageName)
        filledCircleImage = UIImage(named: filledCircleImageName)

        isCorrectButton = UIButton()
        isCorrectButton.setImage(isCorrect ? filledCircleImage : unfilledCircleImage, for: .normal)
        isCorrectButton.addTarget(self, action: #selector(isCorrectButtonTapped), for: .touchUpInside)
        containerView.addSubview(isCorrectButton)

        addOptionTextField = UITextField()
        addOptionTextField.font = UIFont._16RegularFont
        addOptionTextField.layer.cornerRadius = 5
        addOptionTextField.borderStyle = .none
        addOptionTextField.backgroundColor = .clickerGrey6
        addOptionTextField.returnKeyType = .done
        addOptionTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        addOptionTextField.delegate = self

        trashButton = UIButton()
        trashButton.setImage(#imageLiteral(resourceName: "TrashIcon"), for: .normal)
        trashButton.addTarget(self, action: #selector(deleteOption), for: .touchUpInside)
        
        let rightTrashView = UIView(frame: CGRect(x: 0, y: 0, width: trashIconHeight + 13, height: contentView.frame.height))
        addOptionTextField.rightView = rightTrashView
        addOptionTextField.rightViewMode = .always
        rightTrashView.addSubview(trashButton)
        
        containerView.addSubview(addOptionTextField)

        setupConstraints()
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(bottomPadding)
        }

        isCorrectButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(isCorrectButtonLeftPadding)
            make.width.height.equalTo(isCorrectButtonLength)
            make.centerY.equalToSuperview()
        }

        addOptionTextField.snp.updateConstraints { make in
            make.leading.equalTo(isCorrectButton.snp.trailing).offset(addOptionTextFieldLeftPadding)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        trashButton.snp.updateConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(trashIconHeight)
            make.height.equalTo(trashIconHeight)
        }
    }
    
    // MARK: - Configure
    func configure(for mcOptionModel: PollBuilderMCOptionModel, delegate: CreateMCOptionCellDelegate) {
        self.delegate = delegate
        trashButton.isHidden = mcOptionModel.totalOptions <= 2
        switch mcOptionModel.type {
        case .newOption(option: let option, index: let index, isCorrect: let isCorrect):
            self.index = index
            self.isCorrect = isCorrect
            isCorrectButton.setImage(isCorrect ? filledCircleImage : unfilledCircleImage, for: .normal)
            let choiceTag = intToMCOption(index)
            addOptionTextField.attributedPlaceholder = NSAttributedString(string: "Option \(choiceTag)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.clickerGrey2, NSAttributedStringKey.font: UIFont._16RegularFont])
            addOptionTextField.text = option
        default:
            return
        }
    }

    // MARK: - Actions
    @objc func deleteOption() {
        delegate?.createMCOptionCellDidDeleteOption(index: index)
    }
    
    @objc func textFieldDidChange() {
        if let text = addOptionTextField.text {
            delegate?.createMCOptionCellDidUpdateTextField(index: index, text: text, isCorrect: isCorrect)
        }
    }

    @objc func isCorrectButtonTapped() {
        isCorrect = !isCorrect
        delegate?.createMCOptionCellDidUpdateIsCorrect(index: index, text: addOptionTextField.text ?? "", isCorrect: isCorrect)
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
