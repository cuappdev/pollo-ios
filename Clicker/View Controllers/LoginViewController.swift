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
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerGreen
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        signInButton = GIDSignInButton()
        signInButton.colorScheme = .light
        view.addSubview(signInButton)
        
        setupConstraints()
    }
    
    // MARK: - CONSTRAINTS
    func setupConstraints() {
        signInButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-60)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.snp.width).multipliedBy(0.3)
            make.height.equalTo(150)
        }
    }
}
