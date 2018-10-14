//
//  QuestionCell.swift
//  Clicker
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class QuestionCell: UICollectionViewCell {
    
    // MARK: - View vars
    var questionLabel: UILabel!
    
    // MARK: - Constants
    let questionLabelWidthScaleFactor: CGFloat = 0.75
    let moreButtonWidth: CGFloat = 25
    let untitledPollString = "Untitled Poll"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clickerWhite
        setupViews()
    }
    
    // MARK: - Layout
    func setupViews() {
        questionLabel = UILabel()
        questionLabel.font = ._20HeavyFont
        questionLabel.numberOfLines = 0
        questionLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(questionLabel)
    }
    
    override func updateConstraints() {
        questionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(LayoutConstants.cardHorizontalPadding)
            make.trailing.equalToSuperview().inset(LayoutConstants.cardHorizontalPadding)
            make.top.equalToSuperview()
        }
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(for questionModel: QuestionModel) {
        let isUntitledPoll = questionModel.question == ""
        questionLabel.text = isUntitledPoll ? untitledPollString : questionModel.question
        questionLabel.textColor = isUntitledPoll ? .clickerGrey2 : .black
        questionLabel.alpha = isUntitledPoll ? 0.5 : 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
