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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    var pollsNavigationController: UINavigationController!
    var didSignInSilently: Bool = false
    let launchScreen = "LaunchScreen"
    private let networking: Networking = URLSession.shared.request
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupWindow()
        setupNavigationController()
        setupGoogleSignIn()
        setupNavBar()
        setupFabric()

        return true
    }
    
    func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        UITextField.appearance().tintColor = .clickerGreen0
        UITextView.appearance().tintColor = .clickerGreen0
    }
    
    func setupNavigationController() {
        let launchScreenVC = UIStoryboard(name: launchScreen, bundle: nil).instantiateInitialViewController() ?? UIViewController()
        pollsNavigationController = UINavigationController(rootViewController: launchScreenVC)
        window?.rootViewController = pollsNavigationController
    }
    
    func setupGoogleSignIn() {
        GIDSignIn.sharedInstance().clientID = Google.googleClientID
        GIDSignIn.sharedInstance().serverClientID = Google.googleClientID
        GIDSignIn.sharedInstance().delegate = self
        if GIDSignIn.sharedInstance().hasAuthInKeychain(){
            didSignInSilently = true
            DispatchQueue.main.async {
                GIDSignIn.sharedInstance().signInSilently()
            }
        } else {
            let loginVC = LoginViewController()
            pollsNavigationController.pushViewController(loginVC, animated: false)
        }
    }
    
    func setupNavBar() {
        pollsNavigationController.setNavigationBarHidden(true, animated: false)
        pollsNavigationController.navigationBar.barTintColor = .clickerBlack1
        pollsNavigationController.navigationBar.isTranslucent = false
        
        let backImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
    }
    
    func setupFabric() {
        #if DEBUG
        print("[Running Clicker in debug configuration]")
        #else
        print("[Running Clicker in release configuration]")
        Crashlytics.start(withAPIKey: Keys.fabricAPIKey.value)
        #endif
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    func getPollSessions(with role: UserRole) -> Future<Response<[Node<Session>]>> {
        return networking(Endpoint.getPollSessions(with: role)).decode(Response<[Node<Session>]>.self)
    }
    
    func userAuthenticate(with idToken: String) -> Future<Response<UserSession>> {
        return networking(Endpoint.userAuthenticate(with: idToken)).decode(Response<UserSession>.self)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            let idToken = user.authentication.idToken ?? ""
            let userId = user.userID ?? "ID" // For client-side use only!
            let fullName = user.profile.name ?? "First Last"
            let givenName = user.profile.givenName ?? "First"
            let familyName = user.profile.familyName ?? "Last"
            let email = user.profile.email ?? "pollo@defaultvalue.com"
            let netId = String(email.split(separator: "@")[0])
            User.currentUser = User(id: userId, name: fullName, netId: netId, givenName: givenName, familyName: familyName, email: email)
            
            let significantEvents: Int = UserDefaults.standard.integer(forKey: Identifiers.significantEventsIdentifier)
            UserDefaults.standard.set(significantEvents + 2, forKey: Identifiers.significantEventsIdentifier)
            
            var joinedSessions = [Session]()
            var createdSessions = [Session]()
            
            userAuthenticate(with: idToken).observe { [weak self] userResult in
                switch userResult {
                case .value(let userResponse):
                    User.userSession = userResponse.data
                    let dispatchGroup = DispatchGroup()
                    dispatchGroup.enter()
                    dispatchGroup.enter()
                    self?.getPollSessions(with: .member).observe { memberResult in
                        switch memberResult {
                        case .value(let memberResponse):
                            var preSessions = [Double : Session]()
                            memberResponse.data.forEach { node in
                                let session = node.node
                                if let updatedAt = session.updatedAt, let latestActivityTimestamp = Double(updatedAt) {
                                    preSessions[latestActivityTimestamp] = Session(id: session.id, name: session.name, code: session.code, latestActivity: getLatestActivity(latestActivityTimestamp: latestActivityTimestamp, code: session.code, role: .member), isLive: session.isLive)
                                }
                            }
                            for time in preSessions.keys.sorted() {
                                joinedSessions.append(preSessions[time]!)
                            }
                        case .error(let memberError):
                            print(memberError)
                        }
                        dispatchGroup.leave()
                    }
                    self?.getPollSessions(with: .admin).observe { adminResult in
                        switch adminResult {
                        case .value(let adminResponse):
                            var preSessions = [Double : Session]()
                            adminResponse.data.forEach { node in
                                let session = node.node
                                if let updatedAt = session.updatedAt, let latestActivityTimestamp = Double(updatedAt) {
                                    preSessions[latestActivityTimestamp] = Session(id: session.id, name: session.name, code: session.code, latestActivity: getLatestActivity(latestActivityTimestamp: latestActivityTimestamp, code: session.code, role: .member), isLive: session.isLive)
                                }
                            }
                            for time in preSessions.keys.sorted() {
                                createdSessions.append(preSessions[time]!)
                            }
                        case .error(let adminError):
                            print(adminError)
                        }
                        dispatchGroup.leave()
                    }
                    dispatchGroup.notify(queue: .main, execute: {
                        guard let `self` = self else { return }
                        DispatchQueue.main.async {
                            let pollsViewController = PollsViewController(joinedSessions: joinedSessions, createdSessions: createdSessions)
                            self.pollsNavigationController.pushViewController(pollsViewController, animated: !self.didSignInSilently)
                        }
                    })
                case .error(let userError):
                    print(userError)
                }
            }
            
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func logout() {
        GIDSignIn.sharedInstance().signOut()
        didSignInSilently = false
        pollsNavigationController.setNavigationBarHidden(true, animated: false)
        pollsNavigationController.popToRootViewController(animated: false)
        pollsNavigationController.pushViewController(LoginViewController(), animated: false)
    }
    
    func requestReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            print("In app rating not supported.")
        }
    }
}
