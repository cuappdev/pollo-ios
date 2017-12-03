//
//  LoginViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 9/24/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit
import GoogleSignIn
import SnapKit

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    var clickerLogo: UIImageView!
    var signInButton: GIDSignInButton!
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        clickerLogo = UIImageView(image: #imageLiteral(resourceName: "clickerLogoBlue"))
        view.addSubview(clickerLogo)
        
        signInButton = GIDSignInButton()
        signInButton.colorScheme = .light
        view.addSubview(signInButton)
        
        setConstraints()
    }
    
    // MARK: - CONSTRAINTS
    func setConstraints() {
        clickerLogo.snp.makeConstraints { (make) in
            make.center.equalTo(view.snp.center)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        signInButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-60)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.snp.width).multipliedBy(0.3)
            make.height.equalTo(150)
        }
    }
}
