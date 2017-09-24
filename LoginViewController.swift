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
        
        signInButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.5, height: 200))
        signInButton.colorScheme = .light
        view.addSubview(signInButton)
        
        signInButton.snp.makeConstraints { (make) in
            make.center.equalTo(view.snp.center)
        }
        
        
    }
    
}
