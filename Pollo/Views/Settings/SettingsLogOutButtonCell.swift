//
//  SettingsLogOutButtonCell.swift
//  Pollo
//
//  Created by Lucy Xu on 3/23/19.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol LogoutButtonCellDelegate: class {
    func logOutButtonCellWasTapped()
}

class SettingsLogOutButtonCell: UICollectionViewCell {
    
    // MARK: Data vars
    weak var delegate: LogoutButtonCellDelegate?
    
    // MARK: Views
    var logOutButton: UIButton!
    
    // MARK: Layout constants
    let logOutButtonOffset = 18
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        logOutButton = UIButton()
        logOutButton.setTitleColor(UIColor.polloGreen, for: .normal)
        logOutButton.titleLabel?.textAlignment = .left
        logOutButton.titleLabel?.font = UIFont._18MediumFont
        logOutButton.contentHorizontalAlignment = .left
        logOutButton.addTarget(self, action: #selector(logOutClicked), for: .touchUpInside)
        contentView.addSubview(logOutButton)
    }
    
    func setupConstraints() {
        logOutButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(logOutButtonOffset)
            make.right.centerY.equalToSuperview()
        }
    }
    
    func configureWith(settingsDataModel: SettingsDataModel) {
        logOutButton.setTitle(settingsDataModel.title, for: .normal)
    }
    
    // MARK: Actions
    @objc func logOutClicked() {
        delegate?.logOutButtonCellWasTapped()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
