//
//  NavigationTitleView.swift
//  Clicker
//
//  Created by eoin on 4/30/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol NavigationTitleViewDelegate {
    func navigationTitleViewGroupControlsButtonTapped()
}

class NavigationTitleView: UIView {

    // MARK: - View vars
    var primaryLabel: UILabel!
    var secondaryLabel: UILabel!
    var groupControlsButton: UIButton!

    // MARK: - Data vars
    var delegate: NavigationTitleViewDelegate?

    
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

        groupControlsButton = UIButton()
        groupControlsButton.backgroundColor = .clear
        groupControlsButton.addTarget(self, action: #selector(groupControlsBtnTapped), for: .touchUpInside)
        addSubview(groupControlsButton)
    }
    
    func configure(primaryText: String, secondaryText: String, delegate: NavigationTitleViewDelegate? = nil) {
        primaryLabel.text = primaryText
        secondaryLabel.text = secondaryText
        self.delegate = delegate
    }
    
    func setupConstraints() {
        primaryLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
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

        groupControlsButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Action
    @objc func groupControlsBtnTapped() {
        delegate?.navigationTitleViewGroupControlsButtonTapped()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
