//
//  ViewController.swift
//  Clicker
//
//  Created by Daniel Li on 2/12/17.
//  Copyright © 2017 cuappdev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GIDSignInUIDelegate {

    var signInBtn: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        signInBtn = GIDSignInButton(frame: CGRect(x:15, y:15, width:100, height:50))
        view.addSubview(signInBtn)
        
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

