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
    var moreButton: UIButton!
    
    // MARK: - Constants
    let horizontalPadding: CGFloat = 14
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
        questionLabel.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        questionLabel.numberOfLines = 0
        questionLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(questionLabel)
        
        moreButton = UIButton()
        moreButton.setImage(#imageLiteral(resourceName: "dots"), for: .normal)
        moreButton.contentMode = .scaleAspectFit
        contentView.addSubview(moreButton)
    }
    
    override func updateConstraints() {
        questionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(horizontalPadding)
            make.width.equalToSuperview().multipliedBy(questionLabelWidthScaleFactor)
            make.top.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints { make in
            make.width.equalTo(moreButtonWidth)
            make.trailing.equalToSuperview().inset(horizontalPadding)
            make.centerY.equalToSuperview()
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
