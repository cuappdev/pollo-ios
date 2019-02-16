//
//  NavigationTitleView.swift
//  Clicker
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
    var primaryLabel: UILabel!
    var secondaryLabel: UILabel!
    var arrowImageView: UIImageView!
    var navigationButton: UIButton!

    // MARK: - Data vars
    weak var delegate: NavigationTitleViewDelegate?

    // MARK: - Constants
    let arrowImageViewWidth: CGFloat = 5.3
    let arrowImageViewHeight: CGFloat = 9.5
    let arrowImageViewLeftPadding: CGFloat = 6
    let arrowImageName = "forward_arrow"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        primaryLabel = UILabel()
        primaryLabel.textColor = .white
        primaryLabel.font = ._16SemiboldFont
        primaryLabel.textAlignment = .center
        addSubview(primaryLabel)
        
        secondaryLabel = UILabel()
        secondaryLabel.textColor = UIColor.white.withAlphaComponent(0.75)
        secondaryLabel.font = ._12MediumFont
        secondaryLabel.textAlignment = .center
        addSubview(secondaryLabel)

        arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: arrowImageName)
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.isHidden = true
        addSubview(arrowImageView)

        navigationButton = UIButton()
        navigationButton.backgroundColor = .clear
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
            make.bottom.equalTo(self.snp.centerY)
            make.height.equalTo(19)
        }
        
        secondaryLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(primaryLabel.snp.bottom).offset(2)
            make.height.equalTo(15)
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
