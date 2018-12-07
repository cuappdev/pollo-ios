//
//  AskQuestionCell.swift
//  Clicker
//
//  Created by Kevin Chan on 12/6/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

protocol AskQuestionCellDelegate {
    func askQuestionCellDidUpdateEditable(_ editable: Bool)
    func askQuestionCellDidUdpateText(_ text: String?)
}

class AskQuestionCell: UICollectionViewCell {

    // MARK: - View vars
    var textField: UITextField!

    // MARK: - Data vars
    var delegate: AskQuestionCellDelegate?

    // MARK: - Constants
    let questionLabelWidthScaleFactor: CGFloat = 0.75
    let moreButtonWidth: CGFloat = 25
    let untitledPollString = "Untitled Poll"
    let editButtonImageName = "dots"

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .clickerWhite

        textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Ask a question...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.clickerGrey2, NSAttributedStringKey.font: UIFont._18RegularFont])
        textField.font = ._18RegularFont
        textField.returnKeyType = .done
        textField.delegate = self
        textField.addTarget(self, action: #selector(updateEditable), for: .allEditingEvents)
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        contentView.addSubview(textField)

        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Configure
    func configure(with delegate: AskQuestionCellDelegate, askQuestionModel: AskQuestionModel) {
        self.delegate = delegate
        self.textField.text = askQuestionModel.currentQuestion
    }


    // MARK: - Actions
    @objc func updateEditable() {
        let isEditable = !(textField.text == "")
        delegate?.askQuestionCellDidUpdateEditable(isEditable)
    }

    @objc func textDidChange() {
        delegate?.askQuestionCellDidUdpateText(textField.text)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AskQuestionCell: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = IntegerConstants.maxQuestionCharacterCount
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }

}
