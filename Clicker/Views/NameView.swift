//
//  BlurView.swift
//  Clicker
//
//  Created by eoin on 4/27/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class NameView: UIView, UITextFieldDelegate {

    var titleField: UITextField!
    var blurView: UIVisualEffectView!    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupViews()
        setupConstraints()
        
    }
    
    func setupViews() {
        backgroundColor = .clear
        
        let blur = UIBlurEffect(style: .regular)
        blurView = UIVisualEffectView(effect: blur)
        addSubview(blurView)
        
        titleField = UITextField()
        titleField.attributedPlaceholder = NSAttributedString(string: "Give your poll a name...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.clickerMediumGray, NSAttributedStringKey.font: UIFont._24MediumFont])
        titleField.font = ._24MediumFont
        titleField.textAlignment = .center
        titleField.delegate = self
        titleField.becomeFirstResponder()
        addSubview(titleField)
        
    }
    
    func setupConstraints() {
        blurView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        
        titleField.snp.makeConstraints { make in
            make.height.equalTo(27)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        removeFromSuperview()
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
