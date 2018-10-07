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
    let questionLabelFontSize: CGFloat = 20
    let questionLabelWidthScaleFactor: CGFloat = 0.75
    let moreButtonWidth: CGFloat = 25
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clickerWhite
        setupViews()
    }
    
    // MARK: - Layout
    func setupViews() {
        questionLabel = UILabel()
        questionLabel.font = UIFont.systemFont(ofSize: questionLabelFontSize, weight: .heavy)
        questionLabel.numberOfLines = 0
        questionLabel.lineBreakMode = .byTruncatingTail
        questionLabel.numberOfLines = 2
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
        questionLabel.text = questionModel.question
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
