//
//  SettingCell.swift
//  Pollo
//
//  Created by Mathew Scullin on 3/12/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

protocol SettingCellDelegate: class {
    func settingCellDidUpdate(_ cell: SettingCell, to newValue: Bool)
}

class SettingCell: UICollectionViewCell {
    
    // MARK: View vars
    var body: UILabel!
    var title: UILabel!
    var toggle: UISwitch!

    // MARK: Data vars
    weak var delegate: SettingCellDelegate?
    
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
        
        backgroundColor = .darkGrey
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        title = UILabel()
        title.font = ._16SemiboldFont
        title.textAlignment = .left
        title.textColor = .white
        contentView.addSubview(title)
        
        body = UILabel()
        body.font = ._12SemiboldFont
        body.textAlignment = .left
        body.textColor = .clickerGrey13
        body.numberOfLines = 2
        contentView.addSubview(body)
        
        toggle = UISwitch()
        toggle.thumbTintColor = .white
        toggle.tintColor = .white
        toggle.onTintColor = .polloGreen
        toggle.isEnabled = true
        toggle.addTarget(self, action: #selector(toggleSwitched), for: .valueChanged)
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

    @objc func toggleSwitched() {
        delegate?.settingCellDidUpdate(self, to: toggle.isOn)
    }

}
