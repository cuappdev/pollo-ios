//
//  AppDelegate.swift
//  Clicker
//
//  Created by Keivan Shahida on 9/20/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit
import Fabric
import FLEX
import GoogleSignIn
import Crashlytics
import StoreKit
import Siren

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    var pollsNavigationController: UINavigationController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.tintColor = .clickerGreen
        window?.makeKeyAndVisible()
        
        // GOOGLE SIGN IN
        GIDSignIn.sharedInstance().clientID = Google.googleClientID
        GIDSignIn.sharedInstance().serverClientID = Google.googleClientID
        GIDSignIn.sharedInstance().delegate = self
        if GIDSignIn.sharedInstance().hasAuthInKeychain(){
            DispatchQueue.main.async {
                GIDSignIn.sharedInstance().signInSilently()
            }
            pollsNavigationController = UINavigationController(rootViewController: PollsViewController())
            pollsNavigationController.setNavigationBarHidden(true, animated: false)
            pollsNavigationController.navigationBar.barTintColor = .clickerDeepBlack
            pollsNavigationController.navigationBar.isTranslucent = false
            window?.rootViewController = pollsNavigationController
        } else {
//            let login = LoginViewController()
            window?.rootViewController = LoginViewController()
//            pollsNavigationController.pushViewController(login, animated: false)
            //window?.rootViewController?.present(login, animated: false, completion: nil)
        }
        
//        // SIREN
//        let siren = Siren.shared
//        siren.alertType = .option
//        siren.alertMessaging = SirenAlertMessaging(updateTitle: "Update Available", updateMessage: "A new version of Pollo is available! Please update now.", updateButtonMessage: "Update", nextTimeButtonMessage: "Next Time", skipVersionButtonMessage: "Skip this version")
//        siren.checkVersion(checkType: .immediately)
        
        let backImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        
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
            User.currentUser = User(id: userId!, name: fullName!, netId: netId!, givenName: givenName!, familyName: familyName!, email: email!)
            
            
            if let significantEvents: Int = UserDefaults.standard.integer(forKey: significantEventsIdentifier){
                UserDefaults.standard.set(significantEvents + 2, forKey: significantEventsIdentifier)
            }
            
            UserAuthenticate(userId: userId!, givenName: givenName!, familyName: familyName!, email: email!).make()
                .done { userSession in
                    print(userSession)
                    User.userSession = userSession
                    self.pollsNavigationController = UINavigationController(rootViewController: PollsViewController())
                    self.pollsNavigationController.setNavigationBarHidden(true, animated: false)
                    self.pollsNavigationController.navigationBar.barTintColor = .clickerDeepBlack
                    self.pollsNavigationController.navigationBar.isTranslucent = false
                    self.window?.rootViewController?.present(self.pollsNavigationController, animated: true, completion: nil)
                } .catch { error in
                    print(error)
            }
            
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
