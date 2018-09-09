//
//  MCChoiceCell.swift
//  Clicker
//
//  Created by Kevin Chan on 9/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol MCChoiceCellDelegate {
    
    func mcChoiceCellWasSelected(at index: Int)
    
}

class MCChoiceCell: UICollectionViewCell {
    
    // MARK: - View vars
    var optionButton: UIButton!
    
    // MARK: - Data vars
    var delegate: MCChoiceCellDelegate!
    var index: Int!
    
    // MARK: - Constants
    let optionButtonFontSize: CGFloat = 16.0
    let optionButtonCornerRadius: CGFloat = 8.0
    let optionButtonBorderWidth: CGFloat = 1.0
    let optionButtonTopPadding: CGFloat = 5
    let optionButtonHorizontalPadding: CGFloat = 14
    
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
            make.leading.equalToSuperview().offset(optionButtonHorizontalPadding)
            make.trailing.equalToSuperview().inset(optionButtonHorizontalPadding)
            make.top.equalToSuperview().offset(optionButtonTopPadding)
            make.bottom.equalToSuperview()
        }
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(with mcChoiceModel: MCChoiceModel, index: Int, delegate: MCChoiceCellDelegate) {
        self.index = index
        self.delegate = delegate
        optionButton.setTitle(mcChoiceModel.option, for: .normal)
    }
    
    // MARK: - Action
    @objc func optionButtonWasPressed() {
        optionButton.backgroundColor = .clickerGreen0
        optionButton.setTitleColor(.white, for: .normal)
        delegate.mcChoiceCellWasSelected(at: index)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
