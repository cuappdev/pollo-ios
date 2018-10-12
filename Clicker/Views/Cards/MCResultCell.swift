//
//  MCResultCell.swift
//  Clicker
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class MCResultCell: UICollectionViewCell {
    
    // MARK: - View vars
    var containerView: UIView!
    var optionLabel: UILabel!
    var numSelectedLabel: UILabel!
    var highlightView: UIView!
    
    // MARK: - Data vars
    var percentSelected: Float!
    
    // MARK: - Constants
    let labelFontSize: CGFloat = 13
    let containerViewCornerRadius: CGFloat = 6
    let containerViewBorderWidth: CGFloat = 0.5
    let containerViewHorizontalPadding: CGFloat = 14
    let containerViewTopPadding: CGFloat = 5
    let optionLabelHorizontalPadding: CGFloat = 14
    let numSelectedLabelTrailingPadding: CGFloat = 14
    let numSelectedLabelWidth: CGFloat = 40
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        setupViews()
    }
    
    // MARK: - Layout
    func setupViews() {
        containerView = UIView()
        containerView.layer.cornerRadius = containerViewCornerRadius
        containerView.layer.borderColor = UIColor.clickerGrey5.cgColor
        containerView.layer.borderWidth = containerViewBorderWidth
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)
        
        optionLabel = UILabel()
        optionLabel.font = UIFont.systemFont(ofSize: labelFontSize, weight: .medium)
        optionLabel.backgroundColor = .clear
        containerView.addSubview(optionLabel)
        
        numSelectedLabel = UILabel()
        numSelectedLabel.font = UIFont.systemFont(ofSize: labelFontSize, weight: .medium)
        numSelectedLabel.backgroundColor = .clear
        numSelectedLabel.textAlignment = .right
        containerView.addSubview(numSelectedLabel)
        
        highlightView = UIView()
        containerView.addSubview(highlightView)
        containerView.sendSubview(toBack: highlightView)
    }
    
    override func updateConstraints() {
        print("update constraints")
        
        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(containerViewHorizontalPadding)
            make.trailing.equalToSuperview().inset(containerViewHorizontalPadding)
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
            make.trailing.equalTo(numSelectedLabel.snp.leading).inset(optionLabelHorizontalPadding)
        }
        
        highlightView.snp.remakeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(percentSelected)
        }
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(for resultModel: MCResultModel, userRole: UserRole) {
        optionLabel.text = resultModel.option
        numSelectedLabel.text = "\(resultModel.numSelected)"
        numSelectedLabel.textColor = .black
        percentSelected = resultModel.percentSelected
        switch userRole {
        case .admin:
            highlightView.backgroundColor = .clickerGreen0
        case .member:
            let isAnswer = resultModel.isAnswer
            highlightView.backgroundColor = isAnswer ? .clickerGreen0 : .clickerGreen1
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
