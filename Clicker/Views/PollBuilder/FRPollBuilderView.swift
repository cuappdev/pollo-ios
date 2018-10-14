//
//  FRPollBuilderView.swift
//  Clicker
//
//  Created by eoin on 4/28/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import SnapKit
import UIKit

class FRPollBuilderView: UIView {
    
    // MARK: - View vars
    var questionTextField: UITextField!
    
    // MARK: - Data vars
    var editable: Bool!
    var session: Session!
    var pollBuilderDelegate: PollBuilderViewDelegate!
    
    // MARK: - Constants
    let popupViewHeight: CGFloat = 95
    
    // MARK: - INITIALIZATION
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layoutSubviews()
        editable = false
        questionTextField.becomeFirstResponder()
    }
    
    func configure(with delegate: PollBuilderViewDelegate) {
        self.pollBuilderDelegate = delegate
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        questionTextField = UITextField()
        questionTextField.attributedPlaceholder = NSAttributedString(string: "Ask a question...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.clickerGrey2, NSAttributedStringKey.font: UIFont._18RegularFont])
        questionTextField.font = ._18RegularFont
        questionTextField.returnKeyType = .done
        questionTextField.delegate = self
        questionTextField.addTarget(self, action: #selector(updateEditable), for: .allEditingEvents)
        addSubview(questionTextField)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        questionTextField.snp.updateConstraints{ make in
            make.size.equalTo(CGSize(width: frame.width, height: 48))
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
    }
    
    @objc func updateEditable() {
        if editable {
            if questionTextField.text == "" {
                pollBuilderDelegate.updateCanDraft(false)
                editable = false
            }
        } else {
            if questionTextField.text != "" {
                pollBuilderDelegate.updateCanDraft(true)
                editable = true
            }
        }
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FRPollBuilderView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = IntegerConstants.maxQuestionCharacterCount
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
}
