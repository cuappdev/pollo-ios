//
//  GoogleManager.swift
//  Clicker
//
//  Created by Kevin Chan on 4/17/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import GoogleSignIn

protocol GoogleManagerDelegate {
    func receiveResponse(user: GIDGoogleUser)// Pass Parameter that you want
}

class GoogleManager {
    var delegate: GoogleManagerDelegate?
    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        self.delegate?.receiveResponse(user: user)
//    }
}
