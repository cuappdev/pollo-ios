//
//  SettingCell.swift
//  Clicker
//
//  Created by Mathew Scullin on 3/12/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class SettingCell: UICollectionViewCell {
    
    // MARK: - View vars
    var title: UILabel!
    var body: UILabel!
    var toggle: UISwitch!
    
    // MARK: Constants
    let bodyHeight: CGFloat = 29
    let bodyWidth: CGFloat = 190
    let bodyTopPadding: CGFloat = 45.5
    let halfCellHeight: CGFloat = 48
    let leftPadding: CGFloat = 16
    let titleTopPadding: CGFloat = 20.5
    let cornerRadius: CGFloat = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        backgroundColor = .clickerGrey10
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        title = UILabel()
        title.font = UIFont._16MediumFont
        title.textAlignment = .left
        title.textColor = .white
        contentView.addSubview(title)
        
        body = UILabel()
        body.font = ._12MediumFont
        body.textAlignment = .left
        body.textColor = .clickerGrey13
        body.numberOfLines = 2
        contentView.addSubview(body)
        
        toggle = UISwitch()
        toggle.thumbTintColor = .white
        toggle.tintColor = .white
        toggle.onTintColor = .clickerGreen0
        toggle.isEnabled = true
        contentView.addSubview(toggle)
    }
    
    private func setupConstraints() {
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(titleTopPadding)
            make.leading.equalToSuperview().offset(leftPadding)
        }
        
        body.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(bodyTopPadding)
            make.leading.equalToSuperview().offset(leftPadding)
            make.height.equalTo(bodyHeight)
            make.width.equalTo(bodyWidth)
        }
        
        toggle.snp.makeConstraints { make in
            make.centerY.equalTo(halfCellHeight)
            make.trailing.equalToSuperview().inset(leftPadding)
        }
    }
    
    func configure(for settings: PollsSettingModel) {
        title.text = settings.title
        body.text = settings.description
        toggle.isOn = settings.isEnabled
    }
}
