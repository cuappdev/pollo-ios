//
//  SettingsInfoCell.swift
//  Clicker
//
//  Created by eoin on 9/15/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class SettingsInfoCell: UICollectionViewCell {
    
    // MARK: Views and VC's
    var titleView: UILabel!
    var descriptionView: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
        
    }
    
    func configureWith(settingsDataModel: SettingsDataModel) {
        titleView.text = settingsDataModel.title
        descriptionView.text = settingsDataModel.description
    }
    
    func setupViews() {
        titleView = UILabel()
        titleView.font = UIFont._18SemiboldFont
        titleView.textAlignment = .left
        contentView.addSubview(titleView)
        
        
        descriptionView = UILabel()
        descriptionView.font = UIFont._16MediumFont
        descriptionView.textColor = UIColor.clickerGrey2
        descriptionView.textAlignment = .left
        descriptionView.numberOfLines = 0
        contentView.addSubview(descriptionView)
    }
    
    func setupConstraints() {
        titleView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().inset(18)
            make.height.equalTo(21.5)
        }
        
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(6)
            make.left.equalTo(titleView.snp.left)
            make.right.equalTo(titleView.snp.right)
            make.bottom.equalToSuperview().inset(18)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
