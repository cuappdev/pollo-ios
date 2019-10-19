//
//  MCResultCell.swift
//  Pollo
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
    var dotView: UIView!
    var highlightView: UIView!
    var innerShadow: CALayer!
    var numSelectedLabel: UILabel!
    var optionLabel: UILabel!
    var selectedDotView: UIView!
    var selectedImageView: UIImageView!
    
    // MARK: - Data vars
    var correctAnswer: String?
    var didLayoutConstraints = false
    var highlightViewWidthConstraint: Constraint!
    var index: Int!
    var percentSelected: Float!
    var showCorrectAnswer = false
    var userRole: UserRole!
    
    // MARK: - Constants
    let checkImageName = "correctanswer"
    let checkImageViewLength: CGFloat = 14
    let containerViewBorderWidth: CGFloat = 0.6
    let containerViewCornerRadius: CGFloat = 8
    let containerViewHeight: CGFloat = 46
    let containerViewTopPadding: CGFloat = 8
    let correctImageName = "correct"
    let dotViewBorderWidth: CGFloat = 2
    let dotViewLength: CGFloat = 23
    let horizontalPadding: CGFloat = 12
    let incorrectImageName = "incorrect"
    let labelFontSize: CGFloat = 13
    let numSelectedLabelTrailingPadding: CGFloat = 16
    let numSelectedLabelWidth: CGFloat = 40
    let selectedImageViewLength: CGFloat = 17
    let selectedDotViewLength: CGFloat = 15
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        setupViews()
    }
    
    // MARK: - Layout
    func setupViews() {
        containerView = UIView()
        containerView.layer.cornerRadius = containerViewCornerRadius
        containerView.layer.borderColor = UIColor.coolGrey.cgColor
        containerView.layer.borderWidth = containerViewBorderWidth
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)
        
        optionLabel = UILabel()
        optionLabel.font = ._14MediumFont
        optionLabel.backgroundColor = .clear
        optionLabel.lineBreakMode = .byTruncatingTail
        optionLabel.textColor = .black
        containerView.addSubview(optionLabel)
        
        numSelectedLabel = UILabel()
        numSelectedLabel.font = ._14MediumFont
        numSelectedLabel.backgroundColor = .clear
        numSelectedLabel.textAlignment = .right
        numSelectedLabel.textColor = .black
        containerView.addSubview(numSelectedLabel)
        
        dotView = UIView()
        dotView.clipsToBounds = true
        dotView.layer.cornerRadius = dotViewLength / 2
        dotView.backgroundColor = .white
        dotView.layer.borderColor = UIColor.blueGrey.cgColor
        dotView.layer.borderWidth = dotViewBorderWidth
        contentView.addSubview(dotView)
        
        selectedDotView = UIView()
        selectedDotView.clipsToBounds = true
        selectedDotView.layer.cornerRadius = selectedDotViewLength / 2
        contentView.addSubview(selectedDotView)
        
        selectedImageView = UIImageView()
        contentView.addSubview(selectedImageView)

        highlightView = UIView()
        containerView.addSubview(highlightView)
        containerView.sendSubviewToBack(highlightView)
        
        checkImageView = UIImageView()
        checkImageView.image = UIImage(named: checkImageName)?.withRenderingMode(.alwaysTemplate)
        checkImageView.tintColor = .charcoalGrey
        containerView.addSubview(checkImageView)
    }
    
    override func updateConstraints() {
        guard let optionLabelText = optionLabel.text else { return }
        let optionLabelWidth = optionLabelText.width(withConstrainedHeight: bounds.height, font: optionLabel.font)
        let maxWidth = bounds.width - numSelectedLabelWidth - horizontalPadding * 4 - checkImageViewLength
        
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
            let highlightViewMaxWidth = Float(self.contentView.bounds.width - horizontalPadding * 2)
            self.highlightViewWidthConstraint?.update(offset: highlightViewMaxWidth * self.percentSelected)
            super.updateConstraints()
            return
        }

        didLayoutConstraints = true
        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(horizontalPadding + (userRole == .admin ? 0 : horizontalPadding + dotViewLength))
            make.trailing.equalToSuperview().inset(horizontalPadding)
            make.height.equalTo(containerViewHeight)
            make.bottom.equalToSuperview()
        }
        
        numSelectedLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(numSelectedLabelTrailingPadding)
            make.width.equalTo(numSelectedLabelWidth)
        }
        
        optionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(horizontalPadding)
            make.trailing.equalToSuperview().inset(horizontalPadding)
            make.centerY.equalToSuperview()
            if showCorrectAnswer {
                make.width.equalTo(optionLabelWidth >= maxWidth ? maxWidth : optionLabelWidth)
            } else {
                make.width.equalTo(maxWidth)
            }
        }
        
        dotView.snp.makeConstraints { make in
            make.width.height.equalTo(dotViewLength)
            make.centerY.equalTo(containerView)
            make.leading.equalToSuperview().offset(horizontalPadding)
        }
        
        selectedDotView.snp.makeConstraints { make in
            make.width.height.equalTo(selectedDotViewLength)
            make.center.equalTo(dotView)
        }
        
        selectedImageView.snp.makeConstraints { make in
            make.width.height.equalTo(selectedImageViewLength)
            make.center.equalTo(dotView)
        }
        
        if showCorrectAnswer {
            updateCheckImageView()
        }

        highlightView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            let highlightViewMaxWidth = Float(contentView.bounds.width - horizontalPadding * 2)
            highlightViewWidthConstraint = make.width.equalTo(0).offset(highlightViewMaxWidth * percentSelected).constraint
        }
        super.updateConstraints()
    }
    
    func updateCheckImageView() {
        checkImageView.image = UIImage(named: checkImageName)?.withRenderingMode(.alwaysTemplate)
        checkImageView.snp.makeConstraints { make in
            make.width.height.equalTo(checkImageViewLength)
            make.leading.equalTo(optionLabel.snp.trailing).offset(horizontalPadding)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Configure
    func configure(for resultModel: MCResultModel, userRole: UserRole, correctAnswer: String?) {
        optionLabel.text = resultModel.option
        percentSelected = resultModel.percentSelected
        numSelectedLabel.text = "\(Int(percentSelected * 100))%"
        self.correctAnswer = correctAnswer
        self.userRole = userRole
        switch userRole {
        case .admin:
            containerView.backgroundColor = .lightGrey
            highlightView.backgroundColor = .polloGreen
            numSelectedLabel.isHidden = false
            dotView.isHidden = true
            optionLabel.textColor = .black
        case .member:
            optionLabel.textColor = .mediumGrey
            numSelectedLabel.isHidden = true
            dotView.isHidden = false
            let isSelected = resultModel.isSelected
            selectedDotView.isHidden = !isSelected
            selectedImageView.isHidden = selectedDotView.isHidden
            let answer = intToMCOption(resultModel.choiceIndex)
            if let correctAnswer = correctAnswer, !correctAnswer.isEmpty {
                if answer == correctAnswer {
                    if isSelected {
                        selectedDotView.backgroundColor = .clear
                        selectedImageView.image = UIImage(named: correctImageName)
                    }
                    showCorrectAnswer = true
                    highlightView.backgroundColor = isSelected ? .lightGreen : .lightGrey
                    highlightView.layer.borderColor = isSelected ? UIColor.polloGreen.cgColor : UIColor.coolGrey.cgColor
                } else {
                    if isSelected {
                        selectedDotView.backgroundColor = .clear
                        selectedImageView.image = UIImage(named: incorrectImageName)
                    }
                    highlightView.backgroundColor = .lightGrey
                    highlightView.layer.borderColor = UIColor.coolGrey.cgColor
                }
            } else {
                if isSelected {
                    selectedDotView.backgroundColor = .coolGrey
                    selectedImageView.image = nil
                }
                highlightView.backgroundColor = .lightGrey
                highlightView.layer.borderColor = UIColor.coolGrey.cgColor
            }
        }
    }

    // MARK: - Updates
    func update(with resultModel: MCResultModel, correctAnswer: String?) {
        optionLabel.text = resultModel.option
        percentSelected = resultModel.percentSelected
        numSelectedLabel.text = "\(Int(percentSelected * 100))%"
        // Update highlightView's width constraint offset
        let highlightViewMaxWidth = Float(self.contentView.bounds.width - horizontalPadding * 2)
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
