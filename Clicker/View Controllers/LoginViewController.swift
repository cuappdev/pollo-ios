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
    
    var signInButton: GIDSignInButton!
    var continueButton: UIButton!
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerGreen
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        signInButton = GIDSignInButton()
        signInButton.colorScheme = .light
        view.addSubview(signInButton)
        
        continueButton = UIButton()
        continueButton.setTitle("Continue", for: .normal)
        continueButton.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
        view.addSubview(continueButton)
        
        setupConstraints()
    }
    
    // MARK: - CONSTRAINTS
    func setupConstraints() {
        signInButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-60)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.snp.width).multipliedBy(0.3)
            make.height.equalTo(150)
        }
        
        continueButton.snp.makeConstraints { make in
            make.height.equalTo(75)
            make.width.equalTo(300)
            make.center.equalToSuperview()
        }
    }
    
    @objc func continueAction() {
        navigationController?.popToRootViewController(animated: true)
    }
}
