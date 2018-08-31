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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        setupViews()
    }
    
    // MARK: - Layout
    func setupViews() {
        containerView = UIView()
        containerView.layer.cornerRadius = containerViewCornerRadius
        containerView.layer.borderColor = UIColor.clickerBorder.cgColor
        containerView.layer.borderWidth = containerViewBorderWidth
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)
        
        optionLabel = UILabel()
        optionLabel.font = UIFont.systemFont(ofSize: labelFontSize, weight: .medium)
        containerView.addSubview(optionLabel)
        
        numSelectedLabel = UILabel()
        numSelectedLabel.font = UIFont.systemFont(ofSize: labelFontSize, weight: .medium)
        numSelectedLabel.textColor = .clickerMediumGrey
        containerView.addSubview(numSelectedLabel)
        
        highlightView = UIView()
        highlightView.backgroundColor = .clickerGreen
        containerView.addSubview(highlightView)
        containerView.sendSubview(toBack: highlightView)
    }
    
    override func updateConstraints() {
        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(containerViewHorizontalPadding)
            make.trailing.equalToSuperview().offset(containerViewHorizontalPadding * -1)
            make.top.equalToSuperview().offset(containerViewTopPadding)
            make.bottom.equalToSuperview()
        }
        
        optionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(optionLabelHorizontalPadding)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(numSelectedLabel.snp.leading).offset(optionLabelHorizontalPadding * -1)
        }
        
        numSelectedLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(numSelectedLabelTrailingPadding * -1)
        }
        
        highlightView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(percentSelected)
        }
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(for resultModel: MCResultModel) {
        optionLabel.text = resultModel.option
        numSelectedLabel.text = "\(resultModel.numSelected)"
        percentSelected = resultModel.percentSelected
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
