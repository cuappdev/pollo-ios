//
//  OptionCell.swift
//  Clicker
//
//  Created by eoin on 4/17/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

protocol MultipleChoiceDelegate {
    func choose(_ choice: Int)
}


class LiveOptionCell: UITableViewCell {
    
    var buttonView: UIButton!
    var chosen: Bool!
    var index: Int!
    var delegate: MultipleChoiceDelegate!
    
    //MARK: - INITIALIZATION
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        setupViews()
        layoutSubviews()
        
        selectionStyle = .none
    }
    
    //MARK: - LAYOUT
    func setupViews() {
        buttonView = UIButton()
        print("seting up cell \(index)")
        buttonView.layer.cornerRadius = 8
        buttonView.clipsToBounds = true
        buttonView.layer.borderWidth = 1.0
        buttonView.layer.borderColor = UIColor.clickerGreen0.cgColor
        buttonView.addTarget(self, action: #selector(chooseMe), for: .touchUpInside)
        addSubview(buttonView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 0, 5, 0))
        
        buttonView.snp.updateConstraints { make in
            make.width.equalToSuperview().offset(-36)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    func setColors(isLive: Bool) {
        if chosen {
            if (isLive) {
                buttonView.backgroundColor = .clickerGreen0
            } else {
                buttonView.backgroundColor = .clickerGreen2
                buttonView.layer.borderColor = UIColor.clickerGreen2.cgColor
            }
            buttonView.setTitleColor(.white, for: .normal)
        } else {
            if (isLive) {
                buttonView.setTitleColor(.clickerGreen0, for: .normal)
                buttonView.layer.borderColor = UIColor.clickerGreen0.cgColor
            } else {
                buttonView.setTitleColor(.clickerGreen2, for: .normal)
                buttonView.layer.borderColor = UIColor.clickerGreen2.cgColor
            }
            buttonView.backgroundColor = .white
        }
    }
    
    
    // MARK - ACTIONS
    @objc func chooseMe() {
        print("choosing cell #\(index). This cell has chosen = \(chosen)")
        delegate.choose(index)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

