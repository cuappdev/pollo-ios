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
    private let containerView = UIView()
    private let dotView = UIView()
    private let highlightView = UIView()
    private let numSelectedLabel = UILabel()
    private let optionLabel = UILabel()
    private let percentSelectedLabel = UILabel()
    private let selectedDotView = UIView()
    private let selectedImageView = UIImageView()
    
    // MARK: - Data vars
    var correctAnswer: Int?
    var didLayoutConstraints = false
    var index: Int!
    var percentSelected: Float!
    var showCorrectAnswer = false
    var userRole: UserRole!
    
    // MARK: - Constants
    let checkImageName = "correctanswer"
    let containerViewBorderWidth: CGFloat = 0.6
    let containerViewCorrectBorderWidth: CGFloat = 1.5
    let containerViewCornerRadius: CGFloat = 8
    let containerViewHeight: CGFloat = 46
    let correctImageName = "correct"
    let dotViewBorderWidth: CGFloat = 2
    let dotViewLength: CGFloat = 23
    let highlightViewBorderWidth: CGFloat = 0.3
    let highlightViewCorrectBorderWidth: CGFloat = 1.0
    let highlightViewCornerRadius: CGFloat = 8
    let horizontalPadding: CGFloat = 12
    let incorrectImageName = "incorrect"
    let numPercentSelectedTrailingPadding: CGFloat = 58
    let numSelectedLabelTopPadding: CGFloat = 23
    let percentSelectedLabelTopPadding: CGFloat = 38
    let selectedDotViewLength: CGFloat = 15
    let selectedImageViewLength: CGFloat = 17
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        setupViews()
    }
    
    // MARK: - Layout
    func setupViews() {
        
        dotView.clipsToBounds = true
        dotView.layer.cornerRadius = dotViewLength / 2
        dotView.backgroundColor = .white
        dotView.layer.borderColor = UIColor.blueGrey.cgColor
        dotView.layer.borderWidth = dotViewBorderWidth
        contentView.addSubview(dotView)
        
        selectedDotView.clipsToBounds = true
        selectedDotView.layer.cornerRadius = selectedDotViewLength / 2
        contentView.addSubview(selectedDotView)
        
        contentView.addSubview(selectedImageView)
        
        containerView.clipsToBounds = true
        containerView.layer.borderColor = UIColor.mediumGrey2.cgColor
        contentView.addSubview(containerView)
        
        highlightView.layer.cornerRadius = highlightViewCornerRadius
        highlightView.clipsToBounds = true
        highlightView.layer.borderWidth = highlightViewBorderWidth
        containerView.addSubview(highlightView)
        
        optionLabel.font = ._14MediumFont
        optionLabel.backgroundColor = .clear
        optionLabel.lineBreakMode = .byTruncatingTail
        optionLabel.textColor = .black
        containerView.addSubview(optionLabel)
        
        numSelectedLabel.font = ._14MediumFont
        numSelectedLabel.textAlignment = .center
        numSelectedLabel.textColor = .black
        contentView.addSubview(numSelectedLabel)
        
        percentSelectedLabel.font = ._12SemiboldFont
        percentSelectedLabel.textAlignment = .center
        percentSelectedLabel.textColor = .blueGrey
        contentView.addSubview(percentSelectedLabel)
    }
    
    override func updateConstraints() {
        guard let optionLabelText = optionLabel.text else { return }
        let optionLabelWidth = optionLabelText.width(withConstrainedHeight: bounds.height, font: optionLabel.font)
        let maxWidth = bounds.width - horizontalPadding - numPercentSelectedTrailingPadding - 2 * horizontalPadding
        
        // If we already laid out constraints before, we should only update the
        // highlightView width constraint
        if didLayoutConstraints {
            let useMaxWidth = optionLabelWidth >= maxWidth || !showCorrectAnswer
            optionLabel.snp.updateConstraints { make in
                make.width.equalTo(useMaxWidth ? maxWidth : optionLabelWidth)
            }
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self = self else { return }
                self.highlightView.snp.remakeConstraints { make in
                    make.leading.top.bottom.equalToSuperview()
                    make.width.equalToSuperview().multipliedBy(self.percentSelected)
                }
                self.layoutIfNeeded()
            }
            super.updateConstraints()
            return
        }

        didLayoutConstraints = true
        
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
        
        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(horizontalPadding + (userRole == .admin ? 0 : horizontalPadding + dotViewLength))
            make.trailing.equalToSuperview().inset(numPercentSelectedTrailingPadding)
            make.height.equalTo(containerViewHeight)
            make.bottom.equalToSuperview()
        }
        
        optionLabel.snp.makeConstraints { make in

            make.leading.equalToSuperview().offset(horizontalPadding)
            make.trailing.lessThanOrEqualToSuperview().inset(horizontalPadding)
//            make.trailing.equalToSuperview().inset(horizontalPadding)
            make.centerY.equalToSuperview()
            if showCorrectAnswer {
                make.width.equalTo(optionLabelWidth >= maxWidth ? maxWidth : optionLabelWidth)
            } else {
                make.width.equalTo(maxWidth)
            }
        }

        highlightView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(percentSelected)
        }
        
        numSelectedLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(numSelectedLabelTopPadding)
            make.leading.equalTo(containerView.snp.trailing).offset(horizontalPadding/3)
            make.trailing.equalToSuperview().inset(horizontalPadding/3)
        }
        percentSelectedLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(percentSelectedLabelTopPadding)
            make.leading.equalTo(containerView.snp.trailing).offset(horizontalPadding/3)
            make.trailing.equalToSuperview().inset(horizontalPadding/3)
        }

        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(for resultModel: MCResultModel, userRole: UserRole, correctAnswer: Int?) {
        self.correctAnswer = correctAnswer
        self.userRole = userRole
        
        numSelectedLabel.text = "\(resultModel.numSelected)"
        
        optionLabel.text = resultModel.option
        optionLabel.textColor = userRole == .admin ? .black : .mediumGrey
        
        percentSelected = resultModel.percentSelected
        percentSelectedLabel.text = "(\(Int(percentSelected * 100))%)"
        
        dotView.isHidden = userRole == .admin
        
        containerView.backgroundColor = .clear
        containerView.layer.borderColor = UIColor.mediumGrey2.cgColor
        containerView.layer.borderWidth = containerViewBorderWidth
        containerView.layer.cornerRadius = containerViewCornerRadius
        
        // Setup default MC visuals
        let isSelected = resultModel.isSelected
        selectedDotView.isHidden = !isSelected
        selectedDotView.backgroundColor = .coolGrey
        
        selectedImageView.isHidden = selectedDotView.isHidden
        selectedImageView.image = nil
        
        highlightView.backgroundColor = .lightGrey
        highlightView.layer.borderColor = UIColor.coolGrey.cgColor
        highlightView.layer.borderWidth = highlightViewBorderWidth
        highlightView.layer.cornerRadius = highlightViewCornerRadius
        
        // Override default visuals when there is correct answer
        if let correctAnswer = correctAnswer, correctAnswer != -1 {
            let answer = resultModel.choiceIndex
            let selectedCorrectAnswer = answer == correctAnswer
            if selectedCorrectAnswer {
                showCorrectAnswer = true
                
                containerView.layer.borderColor = UIColor.polloGreen.cgColor
                containerView.layer.borderWidth = containerViewCorrectBorderWidth
                
                highlightView.backgroundColor = .lightGreen
                highlightView.layer.borderColor = UIColor.polloGreen.cgColor
                highlightView.layer.borderWidth = highlightViewCorrectBorderWidth
            }
            if isSelected {
                    selectedDotView.backgroundColor = .clear
                    selectedImageView.image = UIImage(named: selectedCorrectAnswer  ? correctImageName : incorrectImageName)
            }
        }
    }

    // MARK: - Updates
    func update(with resultModel: MCResultModel, correctAnswer: Int?) {
        numSelectedLabel.text = "\(resultModel.numSelected)"
        
        optionLabel.text = resultModel.option
        
        percentSelected = resultModel.percentSelected
        percentSelectedLabel.text = "(\(Int(percentSelected * 100))%)"
        
        updateConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showCorrectAnswer = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
