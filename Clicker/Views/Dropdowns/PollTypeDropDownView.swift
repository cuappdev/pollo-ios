//
//  DropDownView.swift
//  Clicker
//
//  Created by eoin on 5/4/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit


protocol PollTypeDropDownDelegate {
    func updateQuestionType()
}

class PollTypeDropDownView: UIView {
    
    var topButton: UIButton!
    var bottomButton: UIButton!
    var line: UIView!
    
    var delegate: PollTypeDropDownDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        backgroundColor = .clickerWhite
        
        topButton = UIButton()
        topButton.setTitleColor(.clickerGreen, for: .normal)
        topButton.titleLabel?.font = ._16SemiboldFont
        topButton.addTarget(self, action: #selector(selectedTop), for: .touchUpInside)
        addSubview(topButton)
        
        bottomButton = UIButton()
        bottomButton.setTitleColor(.clickerBlack, for: .normal)
        bottomButton.titleLabel?.font = ._16RegularFont
        bottomButton.addTarget(self, action: #selector(selectedBottom), for: .touchUpInside)
        addSubview(bottomButton)
        
        line = UIView()
        line.backgroundColor = .clickerBorder
        addSubview(line)
    }
    func setupConstraints() {
        topButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(19)
        }
        
        bottomButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(1.5)
            make.height.equalTo(19)
        }
        
        line.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    @objc func selectedTop() {
        print("top pressed")
        self.isHidden = true
    }
    
    @objc func selectedBottom() {
        print("bottom pressed")
        self.isHidden = true
        delegate.updateQuestionType()
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
