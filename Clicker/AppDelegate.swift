//
//  AppDelegate.swift
//  Clicker
//
//  Created by Keivan Shahida on 9/20/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit
import Fabric
import GoogleSignIn
import Crashlytics
import StoreKit
import Siren

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = TabBarController()
        
        // GOOGLE SIGN IN
        GIDSignIn.sharedInstance().clientID = Google.googleClientID
        GIDSignIn.sharedInstance().serverClientID = Google.googleClientID
        GIDSignIn.sharedInstance().delegate = self
        if GIDSignIn.sharedInstance().hasAuthInKeychain(){
            DispatchQueue.main.async {
                GIDSignIn.sharedInstance().signInSilently()
            }
        } else {
            let login = LoginViewController()
            window?.rootViewController?.present(login, animated: false, completion: nil)
        }
        
        // SIREN
        let siren = Siren.shared
        siren.alertType = .option
        siren.alertMessaging = SirenAlertMessaging(updateTitle: "Update Available", updateMessage: "A new version of Pollo is available! Please update now.", updateButtonMessage: "Update", nextTimeButtonMessage: "Next Time", skipVersionButtonMessage: "Skip this version")
        siren.checkVersion(checkType: .immediately)
        
        // FABRIC
        #if DEBUG
        print("[Running Clicker in debug configuration]")
        #else
        print("[Running Clicker in release configuration]")
        Crashlytics.start(withAPIKey: Keys.fabricAPIKey)
        #endif
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            let userId = user.userID // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            let netId = email?.substring(to: (email?.index(of: "@"))!)
            User.currentUser = User(id: Float(userId!)!, name: "\(givenName) \(familyName)", netId: netId!)
            
            if let significantEvents : Int = UserDefaults.standard.integer(forKey: "significantEvents"){
                UserDefaults.standard.set(significantEvents + 2, forKey:"significantEvents")
            }
            
            window?.rootViewController?.presentedViewController?.dismiss(animated: false, completion: nil)
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
    }

    
    func requestReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            print("In app rating not supported.")
        }
    }
}
