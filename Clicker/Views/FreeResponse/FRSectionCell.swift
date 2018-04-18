//
//  FRSectionCell.swift
//  Clicker
//
//  Created by Jack Schluger on 3/15/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//
 
import SnapKit
import UIKit


class FRSectionCell: QuestionSectionCell {
    
    var session: Session!
    var grayViewBottomConstraint: Constraint!
    var questionDelegate: QuestionDelegate!
    
    var questionTextField: UITextField!
    
    // MARK: - INITIALIZATION
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layoutSubviews()
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        questionTextField = UITextField()
        questionTextField.attributedPlaceholder = NSAttributedString(string: "Ask a question...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.clickerMediumGray, NSAttributedStringKey.font: UIFont._18RegularFont])
        questionTextField.font = ._18RegularFont
        questionTextField.returnKeyType = .done
        questionTextField.delegate = self
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
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


