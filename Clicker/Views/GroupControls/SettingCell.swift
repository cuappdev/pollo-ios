//
//  SettingCell.swift
//  Clicker
//
//  Created by Mathew Scullin on 3/12/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

protocol SettingCellDelegate: class {
    
    func settingCellDidToggle(settingsModel: PollsSettingModel)
    
}

class SettingCell: UICollectionViewCell {
    
    // MARK: - Data vars
    weak var delegate: SettingCellDelegate?
    var settingsModel: PollsSettingModel!
    
    // MARK: - View vars
    var body: UILabel!
    var title: UILabel!
    var toggle: UISwitch!
    
    // MARK: Constants
    let bodyHeight: CGFloat = 29
    let bodyTopPadding: CGFloat = 45.5
    let bodyWidth: CGFloat = 190
    let cornerRadius: CGFloat = 5
    let halfCellHeight: CGFloat = 48
    let leftPadding: CGFloat = 16
    let titleTopPadding: CGFloat = 20.5
    
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
        toggle.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        contentView.addSubview(toggle)
    }
    
    @objc func switchToggled() {
        delegate?.settingCellDidToggle(settingsModel: settingsModel)
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
    
    func configure(settingsModel: PollsSettingModel, delegate: SettingCellDelegate) {
        self.settingsModel = settingsModel
        self.delegate = delegate
        title.text = settingsModel.title
        body.text = settingsModel.description
        toggle.isOn = settingsModel.isEnabled
    }
}
