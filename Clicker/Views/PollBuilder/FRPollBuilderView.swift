//
//  FRPollBuilderView.swift
//  Clicker
//
//  Created by eoin on 4/28/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import SnapKit
import UIKit

class FRPollBuilderView: UIView, UITextFieldDelegate {
    
    let popupViewHeight: CGFloat = 95
    
    var pollBuilderDelegate: PollBuilderViewDelegate!
    
    var session: Session!
    var grayViewBottomConstraint: Constraint!
    
    var questionTextField: UITextField!
    var line: UIView!
    var responseOptionsLabel: UILabel!
    var changeButton: UIButton!
    
    var editable: Bool!
    
    var dropDown: FROptionsDropDownView!
    
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
        
        line = UIView()
        line.backgroundColor = .clickerGrey2
        addSubview(line)
        
        responseOptionsLabel = UILabel()
        responseOptionsLabel.text = "Only you will see responses and votes"
        responseOptionsLabel.textAlignment = .left
        responseOptionsLabel.font = ._14MediumFont
        addSubview(responseOptionsLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        questionTextField.snp.updateConstraints{ make in
            make.size.equalTo(CGSize(width: frame.width, height: 48))
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        line.snp.updateConstraints { make in
            make.height.equalTo(1.5)
            make.width.equalTo(339)
            make.centerX.equalToSuperview()
            make.top.equalTo(questionTextField.snp.bottom).offset(73.5)
        }
        
        responseOptionsLabel.snp.updateConstraints { make in
            responseOptionsLabel.sizeToFit()
            make.left.equalTo(line.snp.left)
            make.top.equalTo(line.snp.bottom).offset(14)
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
