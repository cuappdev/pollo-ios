//
//  AskQuestionCell.swift
//  Pollo
//
//  Created by Kevin Chan on 12/6/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import SnapKit
import UIKit

protocol AskQuestionCellDelegate: class {
    func askQuestionCellDidUpdateEditable(_ editable: Bool)
    func askQuestionCellDidUpdateText(_ text: String?)
    func askQuestionCellDidUpdateHeight(_ height: CGFloat)
}

class AskQuestionCell: UICollectionViewCell {

    // MARK: - View vars
    var questionTextView: UITextView!
    var charCountLabel: UILabel!

    // MARK: - Data vars
    weak var delegate: AskQuestionCellDelegate?
    
    // MARK: - Constants
    let editButtonImageName = "dots"
    let moreButtonWidth: CGFloat = 25
    let questionLabelPlaceholder = "Ask a question..."
    let questionLabelWidthScaleFactor: CGFloat = 0.75
    let charCountLabelPadding: CGFloat = 4
    let untitledPollString = "Untitled Poll"

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .offWhite
        
        questionTextView = UITextView()
        questionTextView.delegate = self
        questionTextView.font = ._18RegularFont
        questionTextView.backgroundColor = .offWhite
        questionTextView.returnKeyType = .done
        questionTextView.isScrollEnabled = false
        contentView.addSubview(questionTextView)
        
        charCountLabel = UILabel()
        charCountLabel.textColor = .blueGrey
        charCountLabel.font = ._12RegularFont
        contentView.addSubview(charCountLabel)

        setUpConstraints()
    }

    // MARK: - Configure
    func configure(with delegate: AskQuestionCellDelegate, askQuestionModel: AskQuestionModel) {
        self.delegate = delegate
        if let currentQuestion = askQuestionModel.currentQuestion {
            questionTextView.text = currentQuestion
            questionTextView.textColor = .black
            charCountLabel.text = "\(questionTextView.text.count)/120"
            updateQuestionTextViewHeight()
        } else {
            questionTextView.text = questionLabelPlaceholder
            questionTextView.textColor = .blueGrey
            charCountLabel.text = nil
        }
    }

    // MARK: - Actions
    func updateEditable() {
        let isEditable = !(questionTextView.text?.isEmpty ?? true)
        delegate?.askQuestionCellDidUpdateEditable(isEditable)
    }

    func updateQuestionTextViewHeight() {
        let questionTextViewWidth = self.contentView.frame.size.width
        let dynamicHeight = questionTextView.sizeForWidth(width: questionTextViewWidth)
        delegate?.askQuestionCellDidUpdateHeight(dynamicHeight)
    }

    func textDidChange() {
        delegate?.askQuestionCellDidUpdateText(questionTextView.text)
    }
    
    func setUpConstraints() {
        questionTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        charCountLabel.snp.makeConstraints { make in
            make.bottom.right.equalTo(questionTextView).inset(charCountLabelPadding)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AskQuestionCell: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let maxLength = IntegerConstants.maxQuestionCharacterCount
        let currentString: NSString = (textView.text ?? "") as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: text) as NSString
        return newString.length <= maxLength
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .blueGrey {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        charCountLabel.text = "\(questionTextView.text.count)/120"
        updateQuestionTextViewHeight()
        updateEditable()
        textDidChange()
    }
    
}

// MARK: - UITextView
extension UITextView {

    func sizeForWidth(width: CGFloat) -> CGFloat {
        let dynamicSize = sizeThatFits(CGSize.init(width: width, height: CGFloat(MAXFLOAT)))
        return dynamicSize.height
    }

}
