//
//  LoginViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 3/20/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.

//
import UIKit
import GoogleSignIn
import SnapKit

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    var gradient: CAGradientLayer!
    var signInButton: GIDSignInButton!
    var welcomeLabel: UILabel!
    var appNameLabel: UILabel!
    var pronunciationLabel: UILabel!
    
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
        welcomeLabel.text = "Welcome to"
        welcomeLabel.font = ._26MediumFont
        welcomeLabel.textColor = .white
        welcomeLabel.adjustsFontSizeToFitWidth = true
        welcomeLabel.textAlignment = .center
        view.addSubview(welcomeLabel)
        
        appNameLabel = UILabel()
        appNameLabel.text = "Pollo"
        appNameLabel.font = ._60HeavyFont
        appNameLabel.textColor = .white
        appNameLabel.adjustsFontSizeToFitWidth = true
        appNameLabel.textAlignment = .center
        view.addSubview(appNameLabel)
        
        pronunciationLabel = UILabel()
        pronunciationLabel.text = "\"Poh-loh\""
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
            make.width.equalTo(249.5)
            make.height.equalTo(31.5)
            make.top.equalToSuperview().offset(194.5)
            make.centerX.equalToSuperview()
        }
        
        appNameLabel.snp.makeConstraints { make in
            make.width.equalTo(welcomeLabel.snp.width)
            make.height.equalTo(71.5)
            make.top.equalTo(welcomeLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        pronunciationLabel.snp.makeConstraints { make in
            make.width.equalTo(welcomeLabel.snp.width)
            make.height.equalTo(19)
            make.top.equalTo(appNameLabel.snp.bottom).offset(14.5)
            make.centerX.equalToSuperview()
        }
        
        signInButton.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.top.equalTo(pronunciationLabel.snp.bottom).offset(28)
            make.centerX.equalToSuperview()
        }
        
    }
}
