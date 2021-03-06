//
//  MCChoiceCell.swift
//  Pollo
//
//  Created by Kevin Chan on 9/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol MCChoiceCellDelegate: class {
    
    func mcChoiceCellWasSelected()
    
}

class MCChoiceCell: UICollectionViewCell {
    
    // MARK: - View vars
    private let optionBackgroundView = UIView()
    private let optionLabel = UILabel()
    private let dotView = UIView()
    private let optionButton = UIButton()
    private let selectedDotView = UIView()
    
    // MARK: - Data vars
    weak var delegate: MCChoiceCellDelegate?
    var pollState: PollState!
    
    // MARK: - Constants
    let dotViewBorderWidth: CGFloat = 2
    let dotViewLength: CGFloat = 23
    let horizontalPadding: CGFloat = 12
    let optionBackgroundViewBorderWidth: CGFloat = 0.6
    let optionBackgroundViewCornerRadius: CGFloat = 8
    let optionBackgroundViewHeight: CGFloat = 46
    let optionButtonBorderWidth: CGFloat = 1.0
    let optionButtonCornerRadius: CGFloat = 8.0
    let optionButtonFontSize: CGFloat = 16.0
    let optionButtonTopPadding: CGFloat = 5
    let selectedDotViewLength: CGFloat = 15
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        setupViews()
    }
    
    // MARK: - Layout
    func setupViews() {
        dotView.backgroundColor = .white
        dotView.clipsToBounds = true
        dotView.layer.cornerRadius = dotViewLength / 2
        dotView.layer.borderColor = UIColor.blueGrey.cgColor
        dotView.layer.borderWidth = dotViewBorderWidth
        contentView.addSubview(dotView)
        
        selectedDotView.clipsToBounds = true
        selectedDotView.layer.cornerRadius = selectedDotViewLength / 2
        contentView.addSubview(selectedDotView)
        
        optionBackgroundView.clipsToBounds = true
        optionBackgroundView.layer.cornerRadius = optionBackgroundViewCornerRadius
        optionBackgroundView.backgroundColor = .white
        optionBackgroundView.layer.borderColor = UIColor.coolGrey.cgColor
        optionBackgroundView.layer.borderWidth = optionBackgroundViewBorderWidth
        contentView.addSubview(optionBackgroundView)
        
        optionLabel.textAlignment = .left
        optionLabel.font = ._14MediumFont
        contentView.addSubview(optionLabel)
        
        optionButton.addTarget(self, action: #selector(optionButtonWasPressed), for: .touchUpInside)
        contentView.addSubview(optionButton)
    }
    
    override func updateConstraints() {
        optionBackgroundView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(horizontalPadding * 2 + dotViewLength)
            make.trailing.equalToSuperview().inset(horizontalPadding)
            make.height.equalTo(optionBackgroundViewHeight)
            make.bottom.equalToSuperview()
        }
        
        optionLabel.snp.makeConstraints { make in
            make.leading.equalTo(optionBackgroundView).offset(horizontalPadding)
            make.trailing.equalTo(optionBackgroundView).inset(horizontalPadding)
            make.centerY.equalTo(optionBackgroundView)
        }
        
        optionButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dotView.snp.makeConstraints { make in
            make.width.height.equalTo(dotViewLength)
            make.leading.equalToSuperview().offset(horizontalPadding)
            make.centerY.equalTo(optionBackgroundView)
        }
        
        selectedDotView.snp.makeConstraints { make in
            make.width.height.equalTo(selectedDotViewLength)
            make.center.equalTo(dotView)
        }
        
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(with mcChoiceModel: MCChoiceModel, pollState: PollState, delegate: MCChoiceCellDelegate) {
        self.delegate = delegate
        self.pollState = pollState
        optionLabel.text = mcChoiceModel.option
        switch pollState {
        case .live:
            configureForLivePoll(isSelected: mcChoiceModel.isSelected)
        case .ended:
            configureForEndedPoll(isSelected: mcChoiceModel.isSelected)
        case .shared:
            return
        }
    }
    
    // MARK: - Action
    @objc func optionButtonWasPressed() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        if pollState == .live {
            delegate?.mcChoiceCellWasSelected()
        }
    }
    
    // MARK: - Helpers
    func configureForLivePoll(isSelected: Bool) {
        optionLabel.textColor = .darkGrey
        selectedDotView.isHidden = !isSelected
        selectedDotView.backgroundColor = .darkestGrey
        optionButton.isEnabled = true
    }
    
    func configureForEndedPoll(isSelected: Bool) {
        optionLabel.textColor = .mediumGrey
        selectedDotView.isHidden = !isSelected
        selectedDotView.backgroundColor = .blueGrey
        optionButton.isEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
