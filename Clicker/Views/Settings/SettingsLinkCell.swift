//
//  SettingsLinkCell.swift
//  Clicker
//
//  Created by eoin on 9/15/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class SettingsLinkCell: UICollectionViewCell {
 
    // MARK: Views and VC's
    var linkButton: UIButton!
    var linkURL: URL!
    
    // MARK: Layout constants
    let standardInset = 18
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        linkButton = UIButton()
        linkButton.setTitleColor(UIColor.clickerGreen0, for: .normal)
        linkButton.titleLabel?.textAlignment = .left
        linkButton.titleLabel?.font = UIFont._18MediumFont
        linkButton.contentHorizontalAlignment = .left
        linkButton.addTarget(self, action: #selector(linkClicked), for: .touchUpInside)
        contentView.addSubview(linkButton)
    }
    
    func setupConstraints() {
        linkButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(standardInset)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func configureWith(settingsDataModel: SettingsDataModel) {
        linkButton.setTitle(settingsDataModel.title, for: .normal)
        linkURL = URL(string: settingsDataModel.description ?? "")
    }
    
    // MARK: Actions
    @objc func linkClicked() {
        UIApplication.shared.open(linkURL)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
