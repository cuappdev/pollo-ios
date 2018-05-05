//
//  FRPollBuilderView.swift
//  Clicker
//
//  Created by eoin on 4/28/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import SnapKit
import UIKit
//import DropDown

class FRPollBuilderView: UIView, UITextFieldDelegate {
    
    let popupViewHeight: CGFloat = 95
    
    var pollBuilderDelegate: PollBuilderDelegate!
    
    var session: Session!
    var grayViewBottomConstraint: Constraint!
    var questionDelegate: QuestionDelegate!
    
    var questionTextField: UITextField!
    var line: UIView!
    var responseOptionsLabel: UILabel!
    var changeButton: UIButton!
    
    var dropDown: FROptionsDropDownView!
    
    // MARK: - INITIALIZATION
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layoutSubviews()
        setupDropDown()
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        questionTextField = UITextField()
        questionTextField.attributedPlaceholder = NSAttributedString(string: "Ask a question...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.clickerMediumGray, NSAttributedStringKey.font: UIFont._18RegularFont])
        questionTextField.font = ._18RegularFont
        questionTextField.returnKeyType = .done
        questionTextField.delegate = self
        addSubview(questionTextField)
        
        line = UIView()
        line.backgroundColor = .clickerMediumGray
        addSubview(line)
        
        responseOptionsLabel = UILabel()
        responseOptionsLabel.text = "Only you will see responses and votes"
        responseOptionsLabel.textAlignment = .left
        responseOptionsLabel.font = ._14MediumFont
        addSubview(responseOptionsLabel)
        
        changeButton = UIButton(type: .system)
        changeButton.setTitle("Change", for: .normal)
        changeButton.setTitle("Done", for: .selected)
        changeButton.titleLabel?.font = ._14MediumFont
        changeButton.titleLabel?.textColor = .clickerBlue
        changeButton.backgroundColor = .clear
        changeButton.titleLabel?.frame = changeButton.frame
        changeButton.addTarget(self, action: #selector(changeButtonPressed), for: .touchUpInside)
        addSubview(changeButton)
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
        
        changeButton.snp.updateConstraints { make in
            changeButton.sizeToFit()
            make.centerY.equalTo(responseOptionsLabel.snp.centerY)
            make.left.equalTo(responseOptionsLabel.snp.right).offset(10)
        }
    }
    
    func setupDropDown() {
        dropDown = FROptionsDropDownView()
        addSubview(dropDown)
        
        dropDown.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(111)
            make.top.equalTo(responseOptionsLabel.snp.bottom).offset(14)
        }
        
        dropDown.isHidden = true
    }
    
    @objc func changeButtonPressed() {
        dropDown.isHidden = !dropDown.isHidden
        changeButton.isSelected = !changeButton.isSelected
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
