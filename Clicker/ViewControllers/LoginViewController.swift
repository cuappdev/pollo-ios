//
//  LoginViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 3/20/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.

//

import GoogleSignIn
import SnapKit
import UIKit

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    var appNameLabel: UILabel!
    var gradient: CAGradientLayer!
    var pronunciationLabel: UILabel!
    var signInButton: GIDSignInButton!
    var welcomeLabel: UILabel!
    
    // MARK: - CONSTANTS
    let appNameLabelHeight: CGFloat = 71.5
    let appNameLabelOffset: CGFloat = 5
    let appNameLabelText: String = "Pollo"
    let pronunciationLabelHeight: CGFloat = 19
    let pronunciationLabelText: String = "\"Poh-loh\""
    let pronunciationLabelTopOffset: CGFloat = 14.5
    let signInButtonHeight: CGFloat = 40
    let signInButtonTopOffset: CGFloat = 28
    let signInButtonWidth: CGFloat = 200
    let welcomeLabelHeight: CGFloat = 31.5
    let welcomeLabelText: String = "Welcome to"
    let welcomeLabelTopScaleFactor: CGFloat = 0.3
    let welcomeLabelWidth: CGFloat = 249.5
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradient = CAGradientLayer()
        gradient.colors = [UIColor.bluishGreen.cgColor, UIColor.aquaMarine.cgColor]
        gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
        
        welcomeLabel = UILabel()
        welcomeLabel.text = welcomeLabelText
        welcomeLabel.font = ._26MediumFont
        welcomeLabel.textColor = .white
        welcomeLabel.adjustsFontSizeToFitWidth = true
        welcomeLabel.textAlignment = .center
        view.addSubview(welcomeLabel)
        
        appNameLabel = UILabel()
        appNameLabel.text = appNameLabelText
        appNameLabel.font = ._60HeavyFont
        appNameLabel.textColor = .white
        appNameLabel.adjustsFontSizeToFitWidth = true
        appNameLabel.textAlignment = .center
        view.addSubview(appNameLabel)
        
        pronunciationLabel = UILabel()
        pronunciationLabel.text = pronunciationLabelText
        pronunciationLabel.font = ._18MediumItalicFont
        pronunciationLabel.textColor = .white
        pronunciationLabel.adjustsFontSizeToFitWidth = true
        pronunciationLabel.textAlignment = .center
        view.addSubview(pronunciationLabel)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        signInButton = GIDSignInButton()
        signInButton.style = .wide
        signInButton.colorScheme = .light
        view.addSubview(signInButton)
        
        setupConstraints()
    }
    
    // MARK: - CONSTRAINTS
    func setupConstraints() {
        welcomeLabel.snp.makeConstraints { make in
            make.width.equalTo(welcomeLabelWidth)
            make.height.equalTo(welcomeLabelHeight)
            make.top.equalToSuperview().offset(view.frame.height * welcomeLabelTopScaleFactor)
            make.centerX.equalToSuperview()
        }
        appNameLabel.snp.makeConstraints { make in
            make.width.equalTo(welcomeLabel.snp.width)
            make.height.equalTo(appNameLabelHeight)
            make.top.equalTo(welcomeLabel.snp.bottom).inset(appNameLabelOffset)
            make.centerX.equalToSuperview()
        }
        pronunciationLabel.snp.makeConstraints { make in
            make.width.equalTo(welcomeLabel.snp.width)
            make.height.equalTo(pronunciationLabelHeight)
            make.top.equalTo(appNameLabel.snp.bottom).offset(pronunciationLabelTopOffset)
            make.centerX.equalToSuperview()
        }
        signInButton.snp.makeConstraints { make in
            make.width.equalTo(signInButtonWidth)
            make.height.equalTo(signInButtonHeight)
            make.top.equalTo(pronunciationLabel.snp.bottom).offset(signInButtonTopOffset)
            make.centerX.equalToSuperview()
        }
    }
}
