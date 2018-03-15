//
//  MCSectionCell.swift
//  Clicker
//
//  Created by Kevin Chan on 2/22/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//
 
import SnapKit
import UIKit

protocol StartFRQuestionDelegate {
    func startFRQuestion(question: String, newQuestionDelegate: NewQuestionDelegate)
}

class FRSectionCell: UICollectionViewCell, UITextFieldDelegate, NewQuestionDelegate {
    
    var session: Session!
    var questionTextField: UITextField!
    var startQuestionButton: UIButton!
    var grayView: UIView!
    var grayViewBottomConstraint: Constraint!
    var startFRQuestionDelegate: StartFRQuestionDelegate!
    var followUpQuestionDelegate: FollowUpQuestionDelegate!
    
    //MARK: - INITIALIZATION
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Add Keyboard Handlers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        backgroundColor = .clickerBackground
        
        setupViews()
        layoutSubviews()
    }
    
    //MARK: - POLLING
    @objc func startQuestion() {
        if let question = questionTextField.text {
            startFRQuestionDelegate.startFRQuestion(question: question, newQuestionDelegate: self)
        } else {
            startFRQuestionDelegate.startFRQuestion(question: "", newQuestionDelegate: self)
            }
    }
    
    //MARK: - LAYOUT
    func setupViews() {
        questionTextField = UITextField()
        questionTextField.placeholder = "Add Question"
        questionTextField.font = UIFont.systemFont(ofSize: 21)
        questionTextField.backgroundColor = .white
        questionTextField.layer.sublayerTransform = CATransform3DMakeTranslation(18, 0, 0)
        questionTextField.returnKeyType = UIReturnKeyType.done
        questionTextField.delegate = self
        addSubview(questionTextField)
        
        grayView = UIView()
        grayView.backgroundColor = .clickerBackground
        addSubview(grayView)
        bringSubview(toFront: grayView)
        
        startQuestionButton = UIButton()
        startQuestionButton.backgroundColor = .clickerBlue
        startQuestionButton.layer.cornerRadius = 8
        startQuestionButton.setTitle("Start Question", for: .normal)
        startQuestionButton.setTitleColor(.white, for: .normal)
        startQuestionButton.titleLabel?.font = UIFont._18SemiboldFont
        startQuestionButton.addTarget(self, action: #selector(startQuestion), for: .touchUpInside)
        grayView.addSubview(startQuestionButton)
        
        grayView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(91)
            make.centerX.equalToSuperview()
            self.grayViewBottomConstraint = make.bottom.equalTo(0).constraint
        }
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        questionTextField.snp.updateConstraints{ make in
            make.size.equalTo(CGSize(width: frame.width, height: 61))
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        startQuestionButton.snp.updateConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.90)
            make.height.equalTo(55)
            make.center.equalToSuperview()
        }
    }
    
    
    // MARK: - NewQuestionDelegate
    
    func creatingNewQuestion() {
        // Notify that we are in a Follow Up question
        //followUpQuestionDelegate.inFollowUpQuestion()
        questionTextField.text = ""
    }
    
    // MARK: - KEYBOARD
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.keyWindow
                let safeBottomPadding = window?.safeAreaInsets.bottom
                grayViewBottomConstraint.update(offset: safeBottomPadding! - keyboardSize.height)
            } else {
                grayViewBottomConstraint.update(offset: -keyboardSize.height)
            }
            layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            grayViewBottomConstraint.update(offset: 0)
            layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


