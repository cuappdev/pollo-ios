//
//  FROptionCell.swift
//  Clicker
//
//  Created by Kevin Chan on 9/9/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol FROptionCellDelegate: class {
    
    func frOptionCellDidReceiveUpvote(for text: String)
    
}

class FROptionCell: UICollectionViewCell {
    
    // MARK: - View vars
    var numUpvotedLabel: UILabel!
    var optionLabel: UILabel!
    var separatorLineView: UIView!
    var upvoteButton: UIButton!
    var upvoteImageView: UIImageView!
    
    // MARK: - Data vars
    weak var delegate: FROptionCellDelegate?
    var didUpvote: Bool!
    
    // MARK: - Constants
    let defaultNumUpvotedText = "0"
    let numUpvotedLabelRightPadding: CGFloat = 13
    let numUpvotedLabelWidth: CGFloat = 24
    let optionLabelFontSize: CGFloat = 14
    let optionLabelWidthScaleFactor: CGFloat = 0.8
    let separatorLineViewHeight: CGFloat = 1
    let upvoteButtonWidth: CGFloat = 50
    let upvoteImageViewHeight: CGFloat = 10
    
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
        
        numUpvotedLabel = UILabel()
        numUpvotedLabel.font = UIFont._12SemiboldFont
        numUpvotedLabel.textColor = .clickerGrey2
        numUpvotedLabel.text = defaultNumUpvotedText
        numUpvotedLabel.textAlignment = .center
        contentView.addSubview(numUpvotedLabel)
        
        upvoteImageView = UIImageView()
        upvoteImageView.image = UIImage(named: "upvote-grey")
        upvoteImageView.contentMode = .scaleAspectFit
        contentView.addSubview(upvoteImageView)

        upvoteButton = UIButton()
        upvoteButton.addTarget(self, action: #selector(upvoteFROption), for: .touchUpInside)
        contentView.addSubview(upvoteButton)
        contentView.bringSubviewToFront(upvoteButton)
        
        separatorLineView = UIView()
        separatorLineView.backgroundColor = .clickerGrey5
        contentView.addSubview(separatorLineView)
    }
    
    override func updateConstraints() {
        optionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(LayoutConstants.cardHorizontalPadding)
            make.width.equalToSuperview().multipliedBy(optionLabelWidthScaleFactor)
            make.centerY.equalToSuperview()
        }
        
        numUpvotedLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(numUpvotedLabelRightPadding)
            make.top.equalTo(contentView.snp.centerY)
            make.width.equalTo(numUpvotedLabelWidth)
        }
        
        upvoteImageView.snp.makeConstraints { make in
            make.centerX.equalTo(numUpvotedLabel.snp.centerX)
            make.bottom.equalTo(contentView.snp.centerY)
            make.height.equalTo(upvoteImageViewHeight)
        }

        upvoteButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(upvoteButtonWidth)
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
        let numUpvotedLabelTextColor: UIColor = frOptionModel.didUpvote ? .clickerGreen0 : .clickerGrey2
        numUpvotedLabel.textColor = numUpvotedLabelTextColor
        numUpvotedLabel.text = "\(frOptionModel.numUpvoted)"
        let upvoteImageViewImage = frOptionModel.didUpvote ? UIImage(named: "upvote-green"): UIImage(named: "upvote-grey")
        upvoteImageView.image = upvoteImageViewImage
    }

    // MARK: - Updates
    func update(with frOptionModel: FROptionModel) {
        self.didUpvote = frOptionModel.didUpvote
        optionLabel.text = frOptionModel.option
        let numUpvotedLabelTextColor: UIColor = frOptionModel.didUpvote ? .clickerGreen0 : .clickerGrey2
        numUpvotedLabel.textColor = numUpvotedLabelTextColor
        numUpvotedLabel.text = "\(frOptionModel.numUpvoted)"
        let upvoteImageViewImage = frOptionModel.didUpvote ? UIImage(named: "upvote-green"): UIImage(named: "upvote-grey")
        upvoteImageView.image = upvoteImageViewImage
    }

    // MARK: - Actions
    @objc func upvoteFROption() {
        delegate?.frOptionCellDidReceiveUpvote(for: optionLabel.text ?? "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
