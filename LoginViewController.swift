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
    
    var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        signInButton = GIDSignInButton()
        signInButton.colorScheme = .light
        view.addSubview(signInButton)
        
        signInButton.snp.makeConstraints { (make) in
            make.center.equalTo(view.snp.center)
            make.width.equalTo(view.snp.width).multipliedBy(0.3)
            make.height.equalTo(150)
        }
        
        
    }
    
}
