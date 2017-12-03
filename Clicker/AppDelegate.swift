//
//  AppDelegate.swift
//  Clicker
//
//  Created by Keivan Shahida on 9/20/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit
import Crashlytics
import Fabric
import GoogleSignIn
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = TabBarController()
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain(){
            DispatchQueue.main.async {
                GIDSignIn.sharedInstance().signInSilently()
            }
        } else {
            let login = LoginViewController()
            window?.rootViewController?.present(login, animated: false, completion: nil)
        }
        
        Fabric.with([Crashlytics.self])
        return true
    }
    
    func application(application: UIApplication,
                     openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL,
                                                    sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication.rawValue] as? String,
                                                    annotation: options[UIApplicationOpenURLOptionsKey.annotation.rawValue])
    }
    
    func application(application: UIApplication,
                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        var options: [String: AnyObject] = [UIApplicationOpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject,
                                            UIApplicationOpenURLOptionsKey.annotation.rawValue: annotation!]
        return GIDSignIn.sharedInstance().handle(url as URL,
                                                    sourceApplication: sourceApplication,
                                                    annotation: annotation)
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            let userId = user.userID
            let idToken = user.authentication.idToken
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            User.currentUser = User(id: userId!, netID: email!, name: fullName!)
            
            if let significantEvents : Int = UserDefaults.standard.integer(forKey: "significantEvents"){
                UserDefaults.standard.set(significantEvents + 2, forKey:"significantEvents")
            }
    
            window?.rootViewController?.presentedViewController?.dismiss(animated: false, completion: nil)
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
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
