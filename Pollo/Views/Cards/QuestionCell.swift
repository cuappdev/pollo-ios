//
//  QuestionCell.swift
//  Pollo
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol QuestionCellDelegate: class {
    func questionCellEditButtonPressed()
}

class QuestionCell: UICollectionViewCell {
    
    // MARK: - Data vars
    var userRole: UserRole!
    weak var delegate: QuestionCellDelegate?
    
    // MARK: - View vars
    var editButton: UIButton!
    var questionLabel: UILabel!
    
    // MARK: - Constants
    let editButtonImageName = "dots"
    let questionLabelWidthScaleFactor: CGFloat = 0.75
    let untitledPollString = "Untitled Poll"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .offWhite
        setupViews()
    }
    
    // MARK: - Layout
    func setupViews() {
        questionLabel = UILabel()
        questionLabel.font = ._20BoldFont
        questionLabel.numberOfLines = 0
        questionLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(questionLabel)
        
        editButton = UIButton()
        editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        editButton.setImage(UIImage(named: editButtonImageName), for: .normal)
        contentView.addSubview(editButton)
    }
    
    @objc func editButtonPressed() {
        delegate?.questionCellEditButtonPressed()
    }
    
    override func updateConstraints() {
        
        switch userRole! {
        case .admin:
            editButton.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(LayoutConstants.cardHorizontalPadding)
                make.top.equalToSuperview()
            }
            
            questionLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(LayoutConstants.cardHorizontalPadding)
                make.trailing.equalTo(editButton.snp.leading).offset(-LayoutConstants.cardHorizontalPadding)
                make.top.equalToSuperview()
            }
        case .member:
            questionLabel.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(LayoutConstants.cardHorizontalPadding)
                make.top.equalToSuperview()
            }
        }
        
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(for questionModel: QuestionModel, userRole: UserRole) {
        self.userRole = userRole
        questionLabel.textAlignment = userRole == .admin ? .left : .center
        let isUntitledPoll = questionModel.question == ""
        questionLabel.text = isUntitledPoll ? untitledPollString : questionModel.question
        questionLabel.textColor = isUntitledPoll ? .blueGrey : .black
        questionLabel.alpha = isUntitledPoll ? 0.5 : 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
