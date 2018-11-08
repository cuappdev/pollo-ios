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
    var nameLabel: UILabel!
    var codeLabel: UILabel!
    var groupControlsButton: UIButton!

    // MARK: - Data vars
    var name: String!
    var code: String!
    var delegate: NavigationTitleViewDelegate?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        nameLabel = UILabel()
        nameLabel.textColor = .white
        nameLabel.font = ._16SemiboldFont
        nameLabel.textAlignment = .center
        addSubview(nameLabel)
    
        
        codeLabel = UILabel()
        codeLabel.textColor = UIColor.white.withAlphaComponent(0.75)
        codeLabel.font = ._12MediumFont
        codeLabel.textAlignment = .center
        addSubview(codeLabel)

        groupControlsButton = UIButton()
        groupControlsButton.backgroundColor = .clear
        groupControlsButton.addTarget(self, action: #selector(groupControlsBtnTapped), for: .touchUpInside)
        addSubview(groupControlsButton)
    }
    
    func configure(name: String?, code: String?, delegate: NavigationTitleViewDelegate? = nil) {
        self.code = "Code: \(code ?? "")"
        if let _ = name { self.name = name } else { self.name = code }

        nameLabel.text = self.name
        codeLabel.text = self.code
        self.delegate = delegate
    }
    
    func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
            make.height.equalTo(19)
        }
        
        codeLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
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
