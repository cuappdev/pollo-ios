//
//  FRSectionCell.swift
//  Clicker
//
//  Created by Jack Schluger on 3/15/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//
 
import SnapKit
import UIKit


class FRSectionCell: QuestionSectionCell, NewQuestionDelegate {
    
    var session: Session!
    var grayViewBottomConstraint: Constraint!
    var questionDelegate: QuestionDelegate!
    
    var questionTextField: UITextField!
    
    //MARK: - INITIALIZATION
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layoutSubviews()
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        questionTextField.snp.updateConstraints{ make in
            make.size.equalTo(CGSize(width: frame.width, height: 61))
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
    }
    
    
    // MARK: - NewQuestionDelegate
    
    func creatingNewQuestion() {
        // Notify that we are in a Follow Up question
        questionDelegate.inFollowUpQuestion()
        questionTextField.text = ""
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


