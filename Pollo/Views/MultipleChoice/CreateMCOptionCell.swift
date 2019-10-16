//
//  CreateMCOptionCell.swift
//  Pollo
//
//  Created by Kevin Chan on 2/22/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

protocol CreateMCOptionCellDelegate: class {

    func createMCOptionCellDidDeleteOption(index: Int)
    func createMCOptionCellDidUpdateIsCorrect(index: Int, text: String, isCorrect: Bool)
    func createMCOptionCellDidUpdateTextField(index: Int, text: String, isCorrect: Bool)

}

class CreateMCOptionCell: UICollectionViewCell, UITextFieldDelegate {

    // MARK: Views
    var addOptionTextField: UITextField!
    var containerView: UIView!
    var filledCircleImage: UIImage!
    var isCorrectButton: UIButton!
    var trashButton: UIButton!
    var unfilledCircleImage: UIImage!
    
    // MARK: Data
    var index: Int!
    var isCorrect: Bool = false
    weak var delegate: CreateMCOptionCellDelegate?

    // MARK: - Constants
    let addOptionTextFieldLeftPadding: CGFloat = 8
    let bottomPadding: CGFloat = 6
    let edgePadding: CGFloat = 18
    let filledCircleImageName = "option_filled"
    let isCorrectButtonLeftPadding: CGFloat = 12
    let isCorrectButtonLength: CGFloat = 23
    let trashIconInset: CGFloat = 13
    let trashIconHeight: CGFloat = 21.5
    let unfilledCircleImageName = "greyEmptyCircle"
    
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
        addOptionTextField.font = ._16RegularFont
        addOptionTextField.layer.cornerRadius = 5
        addOptionTextField.borderStyle = .none
        addOptionTextField.backgroundColor = .clickerGrey6
        addOptionTextField.returnKeyType = .done
        addOptionTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        addOptionTextField.delegate = self
        containerView.addSubview(addOptionTextField)
        
        trashButton = UIButton()
        trashButton.setImage(#imageLiteral(resourceName: "TrashIcon"), for: .normal)
        trashButton.addTarget(self, action: #selector(deleteOption), for: .touchUpInside)
        containerView.addSubview(trashButton)

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
            make.width.height.equalTo(trashIconHeight)
            make.right.equalToSuperview().inset(trashIconInset)
            make.centerY.equalToSuperview()
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
            addOptionTextField.attributedPlaceholder = NSAttributedString(string: "Option \(choiceTag)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.clickerGrey2, NSAttributedString.Key.font: UIFont._16RegularFont])
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
        isCorrect.toggle()
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
