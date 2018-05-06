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
    
    var sessionId: Int!
    var code: String!
    var name: String!
    
    var delegate: CardController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupViews()
        setupConstraints()
        
    }
    
    func setupViews() {
        backgroundColor = .clicker85Black
        
        /*let blur = UIBlurEffect(style: )
        blurView = UIVisualEffectView(effect: blur)
        addSubview(blurView)*/
        
        titleField = UITextField()
        titleField.attributedPlaceholder = NSAttributedString(string: "Give your poll a name...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.clickerMediumGray, NSAttributedStringKey.font: UIFont._24MediumFont])
        if code != name {
            titleField.text = name
        }
        titleField.font = ._24MediumFont
        titleField.textColor = .clickerMediumGray
        titleField.textAlignment = .center
        titleField.delegate = self
        titleField.becomeFirstResponder()
        titleField.keyboardType = .asciiCapable
        addSubview(titleField)
        
    }
    
    func setupConstraints() {
        /*blurView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }*/
        
        titleField.snp.makeConstraints { make in
            make.height.equalTo(27)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        name = textField.text
        name = (name == "") ? code : name
        UpdateSession(id: sessionId, name: name, code: code).make()
            .done { code in
                self.delegate.name = self.name
                self.delegate.updateNavBar()
                self.removeFromSuperview()
            }.catch { error in
                print("error: ", error)
            }
        
        return true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
