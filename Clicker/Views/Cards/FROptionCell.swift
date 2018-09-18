//
//  FROptionCell.swift
//  Clicker
//
//  Created by Kevin Chan on 9/9/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol FROptionCellDelegate {
    
    func frOptionCellDidReceiveUpvote()
    
}

class FROptionCell: UICollectionViewCell {
    
    // MARK: - View vars
    var optionLabel: UILabel!
    var numUpvotedButton: UIButton!
    var upvoteButton: UIButton!
    var separatorLineView: UIView!
    
    // MARK: - Data vars
    var delegate: FROptionCellDelegate!
    var didUpvote: Bool!
    
    // MARK: - Constants
    let optionLabelFontSize: CGFloat = 14
    let optionLabelLeftPadding: CGFloat = 17
    let optionLabelWidthScaleFactor: CGFloat = 0.8
    let numUpvotedButtonFontSize: CGFloat = 12
    let numUpvotedButtonRightPadding: CGFloat = 12
    let numUpvotedButtonHeight: CGFloat = 14
    let upvoteButtonHeight: CGFloat = 10
    let separatorLineViewHeight: CGFloat = 1
    let defaultNumUpvotedTitle = "0"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    // MARK: - Layout
    func setupViews() {
        optionLabel = UILabel()
        optionLabel.font = UIFont.systemFont(ofSize: optionLabelFontSize, weight: .medium)
        optionLabel.numberOfLines = 0
        optionLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(optionLabel)
        
        numUpvotedButton = UIButton()
        numUpvotedButton.titleLabel?.font = UIFont.systemFont(ofSize: numUpvotedButtonFontSize, weight: .semibold)
        numUpvotedButton.setTitleColor(.clickerGrey2, for: .normal)
        numUpvotedButton.setTitle(defaultNumUpvotedTitle, for: .normal)
        numUpvotedButton.addTarget(self, action: #selector(upvoteFROption), for: .touchUpInside)
        contentView.addSubview(numUpvotedButton)
        
        upvoteButton = UIButton()
        upvoteButton.setImage(#imageLiteral(resourceName: "greyTriangle"), for: .normal)
        upvoteButton.addTarget(self, action: #selector(upvoteFROption), for: .touchUpInside)
        contentView.addSubview(upvoteButton)
        
        separatorLineView = UIView()
        separatorLineView.backgroundColor = .clickerGrey5
        contentView.addSubview(separatorLineView)
    }
    
    override func updateConstraints() {
        optionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(optionLabelLeftPadding)
            make.width.equalToSuperview().multipliedBy(optionLabelWidthScaleFactor)
            make.centerY.equalToSuperview()
        }
        
        numUpvotedButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(numUpvotedButtonRightPadding)
            make.top.equalTo(contentView.snp.centerY)
            make.height.equalTo(numUpvotedButtonHeight)
        }
        
        upvoteButton.snp.makeConstraints { make in
            make.centerX.equalTo(numUpvotedButton.snp.centerX)
            make.bottom.equalTo(contentView.snp.centerY)
            make.height.equalTo(upvoteButtonHeight)
        }
        
        separatorLineView.snp.makeConstraints { make in
            make.leading.equalTo(optionLabel.snp.leading)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(separatorLineViewHeight)
        }
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(for frOptionModel: FROptionModel, delegate: FROptionCellDelegate) {
        self.delegate = delegate
        self.didUpvote = frOptionModel.didUpvote
        optionLabel.text = frOptionModel.option
        let numUpvotedButtonTitleColor: UIColor = frOptionModel.didUpvote ? .clickerBlue : .clickerGrey2
        numUpvotedButton.setTitleColor(numUpvotedButtonTitleColor, for: .normal)
        numUpvotedButton.setTitle("\(frOptionModel.numUpvoted)", for: .normal)
        let upvoteButtonImage = frOptionModel.didUpvote ? #imageLiteral(resourceName: "blueTriangle") : #imageLiteral(resourceName: "greyTriangle")
        upvoteButton.setImage(upvoteButtonImage, for: .normal)
    }
    
    // MARK: - Actions
    @objc func upvoteFROption() {
        if !didUpvote { delegate.frOptionCellDidReceiveUpvote() }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
