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
    var optionButton: UIButton!
    
    // MARK: - Data vars
    weak var delegate: MCChoiceCellDelegate?
    var pollState: PollState!
    
    // MARK: - Constants
    let optionButtonBorderWidth: CGFloat = 1.0
    let optionButtonCornerRadius: CGFloat = 8.0
    let optionButtonFontSize: CGFloat = 16.0
    let optionButtonTopPadding: CGFloat = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        setupViews()
    }
    
    // MARK: - Layout
    func setupViews() {
        optionButton = UIButton()
        optionButton.layer.cornerRadius = optionButtonCornerRadius
        optionButton.layer.borderColor = UIColor.clickerGreen0.cgColor
        optionButton.layer.borderWidth = optionButtonBorderWidth
        optionButton.clipsToBounds = true
        optionButton.setTitleColor(.clickerGreen0, for: .normal)
        optionButton.titleLabel?.font = UIFont.systemFont(ofSize: optionButtonFontSize, weight: .medium)
        optionButton.addTarget(self, action: #selector(optionButtonWasPressed), for: .touchUpInside)
        contentView.addSubview(optionButton)
    }
    
    override func updateConstraints() {
        optionButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(LayoutConstants.pollOptionsPadding)
            make.trailing.equalToSuperview().inset(LayoutConstants.pollOptionsPadding)
            make.top.equalToSuperview().offset(optionButtonTopPadding)
            make.bottom.equalToSuperview()
        }
        optionButton.titleLabel?.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(LayoutConstants.pollOptionsPadding)
            make.center.equalToSuperview()
        }
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(with mcChoiceModel: MCChoiceModel, pollState: PollState, delegate: MCChoiceCellDelegate) {
        self.delegate = delegate
        self.pollState = pollState
        optionButton.setTitle(mcChoiceModel.option, for: .normal)
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
        if pollState == .live {
            delegate?.mcChoiceCellWasSelected()
        }
    }
    
    // MARK: - Helpers
    func configureForLivePoll(isSelected: Bool) {
        isSelected ? selectChoice() : deselectChoice()
    }
    
    func configureForEndedPoll(isSelected: Bool) {
        let optionButtonBackgroundColor: UIColor = isSelected ? .clickerGreen1 : .white
        let optionButtonTitleColor: UIColor = isSelected ? .white : .clickerGreen1
        optionButton.backgroundColor = optionButtonBackgroundColor
        optionButton.setTitleColor(optionButtonTitleColor, for: .normal)
        optionButton.layer.borderColor = UIColor.clickerGreen1.cgColor
    }
    
    func selectChoice() {
        optionButton.backgroundColor = .clickerGreen0
        optionButton.setTitleColor(.white, for: .normal)
    }
    
    func deselectChoice() {
        optionButton.backgroundColor = .white
        optionButton.setTitleColor(.clickerGreen0, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
