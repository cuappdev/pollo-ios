//
//  NavigationTitleView.swift
//  Pollo
//
//  Created by eoin on 4/30/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol NavigationTitleViewDelegate: class {
    func navigationTitleViewNavigationButtonTapped()
}

class NavigationTitleView: UIView {

    // MARK: - View vars
    var arrowImageView: UIImageView!
    var navigationButton: UIButton!
    var primaryLabel: UILabel!
    var secondaryLabel: UILabel!

    // MARK: - Data vars
    var buttonWidth: CGFloat!
    weak var delegate: NavigationTitleViewDelegate?

    // MARK: - Constants
    let arrowImageName = "forward_arrow"
    let arrowImageViewHeight: CGFloat = 9.5
    let arrowImageViewLeftPadding: CGFloat = 6
    let arrowImageViewWidth: CGFloat = 5.3
    let labelInset: CGFloat = 10
    let navigationButtonVerticalEdgeInset: CGFloat = 10
    let navigationButtonHorizontalEdgeInset: CGFloat = 30
    let primaryLabelHeight: CGFloat = 19
    let primaryLabelWidth = UIScreen.main.bounds.width * 0.5
    let secondaryLabelHeight: CGFloat = 15
    let secondaryLabelTopOffset: CGFloat = 2
    let secondaryLabelWidth = UIScreen.main.bounds.width * 0.8
    
    init(buttonWidth: CGFloat, frame: CGRect) {
        super.init(frame: frame)
        self.buttonWidth = buttonWidth
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        primaryLabel = UILabel()
        primaryLabel.textColor = .white
        primaryLabel.font = ._16SemiboldFont
        primaryLabel.textAlignment = .center
        primaryLabel.lineBreakMode = .byTruncatingTail
        addSubview(primaryLabel)

        secondaryLabel = UILabel()
        secondaryLabel.textColor = UIColor.white.withAlphaComponent(0.75)
        secondaryLabel.font = ._12SemiboldFont
        secondaryLabel.textAlignment = .center
        secondaryLabel.lineBreakMode = .byTruncatingTail
        addSubview(secondaryLabel)

        arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: arrowImageName)
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.isHidden = true
        addSubview(arrowImageView)

        navigationButton = UIButton()
        navigationButton.backgroundColor = .clear
        navigationButton.contentEdgeInsets = UIEdgeInsets(top: navigationButtonVerticalEdgeInset, left: buttonWidth / 2, bottom: navigationButtonVerticalEdgeInset, right: buttonWidth / 2 + arrowImageViewLeftPadding + arrowImageViewWidth * 3)
        navigationButton.addTarget(self, action: #selector(groupControlsBtnTapped), for: .touchUpInside)
        addSubview(navigationButton)
    }
    
    func configure(primaryText: String, secondaryText: String, userRole: UserRole? = nil, delegate: NavigationTitleViewDelegate? = nil) {
        primaryLabel.text = primaryText
        secondaryLabel.text = secondaryText
        self.delegate = delegate
        arrowImageView.isHidden = delegate == nil || userRole == .member
    }
    
    func setupConstraints() {
        primaryLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(primaryLabelWidth)
            make.bottom.equalTo(self.snp.centerY)
            make.height.equalTo(primaryLabelHeight)
        }
        
        secondaryLabel.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(secondaryLabelWidth)
            make.centerX.equalToSuperview()
            make.top.equalTo(primaryLabel.snp.bottom).offset(secondaryLabelTopOffset)
            make.height.equalTo(secondaryLabelHeight)
        }

        arrowImageView.snp.makeConstraints { make in
            make.width.equalTo(arrowImageViewWidth)
            make.height.equalTo(arrowImageViewHeight)
            make.centerY.equalTo(primaryLabel)
            make.leading.equalTo(primaryLabel.snp.trailing).offset(arrowImageViewLeftPadding)
        }

        navigationButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Action
    @objc func groupControlsBtnTapped() {
        delegate?.navigationTitleViewNavigationButtonTapped()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
