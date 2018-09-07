//
//  PollButtonCell.swift
//  Clicker
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class PollButtonCell: UICollectionViewCell {
    
    var button: UIButton!
    
    // MARK: - Constants
    let buttonTitleFontSize: CGFloat = 13
    let buttonCornerRadius: CGFloat = 20
    let buttonBorderWidth: CGFloat = 1
    let buttonHeight: CGFloat = 38
    let buttonHorizontalPadding: CGFloat = 14
    let liveButtonTitle = "End Question"
    let endedButtonTitle = "Share Results"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: buttonTitleFontSize, weight: .semibold)
        button.layer.cornerRadius = buttonCornerRadius
        contentView.addSubview(button)
    }
    
    // MARK: - Layout
    override func updateConstraints() {
        button.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(buttonHorizontalPadding)
            make.trailing.equalToSuperview().inset(buttonHorizontalPadding)
            make.height.equalTo(buttonHeight)
            make.bottom.equalToSuperview()
        }
        super.updateConstraints()
    }
    
    // MARK: - Configure
    func configure(for pollButtonModel: PollButtonModel) {
        switch pollButtonModel.state {
        case .live:
            button.setTitle(liveButtonTitle, for: .normal)
            button.setTitleColor(.clickerBlack1, for: .normal)
            button.backgroundColor = .white
            button.layer.borderColor = UIColor.clickerBlack1.cgColor
            button.layer.borderWidth = buttonBorderWidth
            break
        default:
            button.setTitle(endedButtonTitle, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .clickerGreen0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
