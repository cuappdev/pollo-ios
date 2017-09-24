//
//  HomeViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 9/24/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit
import GoogleSignIn

class HomeViewController: UIViewController {
    
    var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        signOutButton = UIButton()
        signOutButton.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        view.addSubview(signOutButton)
        
        // TODO: Add snapkit constraints for signout button
    }
    
    @objc func didTapSignOut() {
        GIDSignIn.sharedInstance().signOut()
    }
    
    
}
