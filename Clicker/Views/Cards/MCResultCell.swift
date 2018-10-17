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
    var containerView: UIView!
    var innerShadow: CALayer!
    var optionLabel: UILabel!
    var numSelectedLabel: UILabel!
    var highlightView: UIView!
    
    // MARK: - Data vars
    var percentSelected: Float!
    var highlightViewWidthConstraint: Constraint!
    var didLayoutConstraints: Bool = false
    
    // MARK: - Constants
    let labelFontSize: CGFloat = 13
    let containerViewCornerRadius: CGFloat = 6
    let containerViewBorderWidth: CGFloat = 0.5
    let containerViewTopPadding: CGFloat = 5
    let optionLabelHorizontalPadding: CGFloat = 14
    let numSelectedLabelTrailingPadding: CGFloat = 14
    let numSelectedLabelWidth: CGFloat = 40
    
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
        containerView.addSubview(optionLabel)
        
        numSelectedLabel = UILabel()
        numSelectedLabel.font = UIFont.systemFont(ofSize: labelFontSize, weight: .medium)
        numSelectedLabel.backgroundColor = .clear
        numSelectedLabel.textAlignment = .right
        numSelectedLabel.textColor = .black
        containerView.addSubview(numSelectedLabel)

        highlightView = UIView()
        containerView.addSubview(highlightView)
        containerView.sendSubview(toBack: highlightView)
    }
    
    override func updateConstraints() {
        // If we already layed out constraints before, we should only update the
        // highlightView width constraint
        if didLayoutConstraints {
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
            make.trailing.equalTo(numSelectedLabel.snp.leading).inset(optionLabelHorizontalPadding)
        }

        highlightView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            let highlightViewMaxWidth = Float(contentView.bounds.width - LayoutConstants.pollOptionsPadding * 2)
            highlightViewWidthConstraint = make.width.equalTo(0).offset(highlightViewMaxWidth * percentSelected).constraint
        }
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(for resultModel: MCResultModel, userRole: UserRole) {
        optionLabel.text = resultModel.option
        numSelectedLabel.text = "\(resultModel.numSelected)"
        percentSelected = resultModel.percentSelected
        switch userRole {
        case .admin:
            highlightView.backgroundColor = .clickerGreen0
        case .member:
            let isAnswer = resultModel.isAnswer
            highlightView.backgroundColor = isAnswer ? .clickerGreen0 : .clickerGreen1
        }
    }

    // MARK: - Updates
    func update(with resultModel: MCResultModel) {
        optionLabel.text = resultModel.option
        numSelectedLabel.text = "\(resultModel.numSelected)"
        percentSelected = resultModel.percentSelected
        // Update highlightView's width constraint offset
        let highlightViewMaxWidth = Float(self.contentView.bounds.width - LayoutConstants.pollOptionsPadding * 2)
        self.highlightViewWidthConstraint?.update(offset: highlightViewMaxWidth * self.percentSelected)
        UIView.animate(withDuration: 0.3) {
            self.highlightView.superview?.layoutIfNeeded()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
