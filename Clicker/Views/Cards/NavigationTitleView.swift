//
//  NavigationTitleView.swift
//  Clicker
//
//  Created by eoin on 4/30/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class NavigationTitleView: UIView {

    var name: String!
    var code: String!
    
    var nameLabel: UILabel!
    var codeLabel: UILabel!
    
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
    }
    
    func updateNameAndCode(name: String?, code: String?) {
        self.code = "Code: \(code ?? "")"
        if let _ = name { self.name = name } else { self.name = code }

        nameLabel.text = self.name
        codeLabel.text = self.code
    }
    
    func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(19)
        }
        
        codeLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(1.5)
            make.height.equalTo(15)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
