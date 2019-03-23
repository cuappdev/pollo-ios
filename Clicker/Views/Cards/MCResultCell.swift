//
//  MCResultCell.swift
//  Clicker
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class MCResultCell: UICollectionViewCell {
    
    // MARK: - View vars
    var checkImageView: UIImageView!
    var containerView: UIView!
    var highlightView: UIView!
    var innerShadow: CALayer!
    var numSelectedLabel: UILabel!
    var optionLabel: UILabel!
    
    // MARK: - Data vars
    var correctAnswer: String?
    var didLayoutConstraints = false
    var highlightViewWidthConstraint: Constraint!
    var index: Int!
    var percentSelected: Float!
    var showCorrectAnswer = false
    
    // MARK: - Constants
    let checkImageName = "correctanswer"
    let checkImageViewLength: CGFloat = 14
    let containerViewBorderWidth: CGFloat = 0.5
    let containerViewCornerRadius: CGFloat = 6
    let containerViewTopPadding: CGFloat = 5
    let labelFontSize: CGFloat = 13
    let numSelectedLabelTrailingPadding: CGFloat = 14
    let numSelectedLabelWidth: CGFloat = 40
    let optionLabelHorizontalPadding: CGFloat = 14
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        setupViews()
    }
    
    // MARK: - Layout
    func setupViews() {
        containerView = UIView()
        containerView.layer.cornerRadius = containerViewCornerRadius
        containerView.layer.borderColor = UIColor.clickerGrey5.cgColor
        containerView.layer.borderWidth = containerViewBorderWidth
        containerView.clipsToBounds = true
        
        innerShadow = CALayer()
        innerShadow.frame = CGRect(x: 0, y: 0, width: contentView.frame.width - LayoutConstants.pollOptionsPadding * 2, height: contentView.frame.height)
        let path = UIBezierPath(rect: innerShadow.bounds.insetBy(dx: -20, dy: -20))
        let innerPart = UIBezierPath(rect: innerShadow.bounds).reversing()
        path.append(innerPart)
        innerShadow.shadowPath = path.cgPath
        innerShadow.masksToBounds = true
        innerShadow.shadowColor = UIColor.clickerWhite2.cgColor
        innerShadow.shadowOffset = CGSize.zero
        innerShadow.shadowOpacity = 1
        innerShadow.shadowRadius = 2.5
        containerView.layer.addSublayer(innerShadow)
        
        contentView.addSubview(containerView)
        
        optionLabel = UILabel()
        optionLabel.font = UIFont.systemFont(ofSize: labelFontSize, weight: .medium)
        optionLabel.backgroundColor = .clear
        optionLabel.lineBreakMode = .byTruncatingTail
        containerView.addSubview(optionLabel)
        
        numSelectedLabel = UILabel()
        numSelectedLabel.font = UIFont.systemFont(ofSize: labelFontSize, weight: .medium)
        numSelectedLabel.backgroundColor = .clear
        numSelectedLabel.textAlignment = .right
        numSelectedLabel.textColor = .clickerGrey2
        containerView.addSubview(numSelectedLabel)

        highlightView = UIView()
        containerView.addSubview(highlightView)
        containerView.sendSubview(toBack: highlightView)
        
        checkImageView = UIImageView()
        checkImageView.image = UIImage(named: checkImageName)?.withRenderingMode(.alwaysTemplate)
        checkImageView.tintColor = .charcoalGrey
        containerView.addSubview(checkImageView)
    }
    
    override func updateConstraints() {
        guard let optionLabelText = optionLabel.text else { return }
        let optionLabelWidth = optionLabelText.width(withConstrainedHeight: bounds.height, font: optionLabel.font)
        let maxWidth = bounds.width - numSelectedLabelWidth - optionLabelHorizontalPadding * 4 - checkImageViewLength
        
        // If we already layed out constraints before, we should only update the
        // highlightView width constraint
        if didLayoutConstraints {
            let useMaxWidth = optionLabelWidth >= maxWidth || !showCorrectAnswer
            optionLabel.snp.updateConstraints { make in
                make.width.equalTo(useMaxWidth ? maxWidth : optionLabelWidth)
            }
            if showCorrectAnswer {
                updateCheckImageView()
            }
            let highlightViewMaxWidth = Float(self.contentView.bounds.width - LayoutConstants.pollOptionsPadding * 2)
            self.highlightViewWidthConstraint?.update(offset: highlightViewMaxWidth * self.percentSelected)
            super.updateConstraints()
            return
        }

        didLayoutConstraints = true
        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(LayoutConstants.pollOptionsPadding)
            make.trailing.equalToSuperview().inset(LayoutConstants.pollOptionsPadding)
            make.top.equalToSuperview().offset(containerViewTopPadding)
            make.bottom.equalToSuperview()
        }
        
        numSelectedLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(numSelectedLabelTrailingPadding)
            make.width.equalTo(numSelectedLabelWidth)
        }
        
        optionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(optionLabelHorizontalPadding)
            make.centerY.equalToSuperview()
            if showCorrectAnswer {
                make.width.equalTo(optionLabelWidth >= maxWidth ? maxWidth : optionLabelWidth)
            } else {
                make.width.equalTo(maxWidth)
            }
        }
        
        if showCorrectAnswer {
            updateCheckImageView()
        }

        highlightView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            let highlightViewMaxWidth = Float(contentView.bounds.width - LayoutConstants.pollOptionsPadding * 2)
            highlightViewWidthConstraint = make.width.equalTo(0).offset(highlightViewMaxWidth * percentSelected).constraint
        }
        super.updateConstraints()
    }
    
    func updateCheckImageView() {
        checkImageView.image = UIImage(named: checkImageName)?.withRenderingMode(.alwaysTemplate)
        checkImageView.snp.makeConstraints { make in
            make.width.height.equalTo(checkImageViewLength)
            make.leading.equalTo(optionLabel.snp.trailing).offset(optionLabelHorizontalPadding)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Configure
    func configure(for resultModel: MCResultModel, userRole: UserRole, correctAnswer: String?) {
        optionLabel.text = resultModel.option
        numSelectedLabel.text = "\(resultModel.numSelected)"
        percentSelected = resultModel.percentSelected
        self.correctAnswer = correctAnswer
        switch userRole {
        case .admin:
            highlightView.backgroundColor = .clickerGreen0
        case .member:
            let isSelected = resultModel.isSelected
            let answer = intToMCOption(resultModel.choiceIndex)
            if let correctAnswer = correctAnswer {
                if correctAnswer != "" {
                    if answer == correctAnswer {
                        showCorrectAnswer = true
                        highlightView.backgroundColor = isSelected ? .clickerGreen0 : .clickerGrey5
                        optionLabel.textColor = .black
                    } else {
                        highlightView.backgroundColor = isSelected ? .grapefruit : .clickerGrey5
                        optionLabel.textColor = isSelected ? .black : .clickerGrey2
                    }
                } else {
                    highlightView.backgroundColor = isSelected ? .clickerGreen0 : .clickerGreen1
                    optionLabel.textColor = .black
                }
            } else {
                highlightView.backgroundColor = isSelected ? .clickerGreen0 : .clickerGreen1
            }
        }
    }

    // MARK: - Updates
    func update(with resultModel: MCResultModel, correctAnswer: String?) {
        optionLabel.text = resultModel.option
        numSelectedLabel.text = "\(resultModel.numSelected)"
        percentSelected = resultModel.percentSelected
        // Update highlightView's width constraint offset
        let highlightViewMaxWidth = Float(self.contentView.bounds.width - LayoutConstants.pollOptionsPadding * 2)
        self.highlightViewWidthConstraint?.update(offset: highlightViewMaxWidth * self.percentSelected)
        UIView.animate(withDuration: 0.15) {
            self.highlightView.superview?.layoutIfNeeded()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showCorrectAnswer = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
