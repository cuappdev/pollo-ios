//
//  AppDelegate.swift
//  Pollo
//
//  Created by Keivan Shahida on 9/20/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import AppDevAnnouncements
import Crashlytics
import Fabric
import Firebase
import FutureNova
import StoreKit
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var pollsNavigationController: UINavigationController!
    var didSignInSilently: Bool = false
    let launchScreen = "LaunchScreen"
    private let networking: Networking = URLSession.shared.request
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        setupWindow()
        setupNavigationController()
        setupNetworking()
        //setupGoogleSignIn()
        setupSignIn()
        setupNavBar()
        setupFabric()

        // Setup AppDevAnnouncements
        AnnouncementNetworking.setupConfig(
            scheme: Keys.announcementsScheme,
            host: Keys.announcementsHost,
            commonPath: Keys.announcementsCommonPath,
            announcementPath: Keys.announcementsPath
        )

        return true
    }
    
    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        UITextField.appearance().tintColor = .polloGreen
        UITextView.appearance().tintColor = .polloGreen
    }
    
    private func setupNavigationController() {
        let launchScreenVC = UIStoryboard(name: launchScreen, bundle: nil).instantiateInitialViewController() ?? UIViewController()
        pollsNavigationController = UINavigationController(rootViewController: launchScreenVC)
        window?.rootViewController = pollsNavigationController
    }
    /*
    func setupGoogleSignIn() {
        GIDSignIn.sharedInstance().clientID = Google.googleClientID
        GIDSignIn.sharedInstance().serverClientID = Google.googleClientID
        GIDSignIn.sharedInstance().delegate = self
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            didSignInSilently = true
            DispatchQueue.main.async {
                GIDSignIn.sharedInstance().signInSilently()
            }
        } else {
            let loginVC = LoginViewController()
            pollsNavigationController.pushViewController(loginVC, animated: false)
        }
    }
    */
    private func setupSignIn() {
        let loginVC = LoginViewController()
        pollsNavigationController.pushViewController(loginVC, animated: false)
    }
    
    private func setupNavBar() {
        pollsNavigationController.setNavigationBarHidden(true, animated: false)
        pollsNavigationController.navigationBar.barTintColor = .darkestGrey
        pollsNavigationController.navigationBar.isTranslucent = false
        
        let backImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
    }
    
    private func setupFabric() {
        #if DEBUG
        print("[Running Pollo in debug configuration]")
        #else
        print("[Running Pollo in release configuration]")
        Crashlytics.start(withAPIKey: Keys.fabricAPIKey)
        #endif
    }

    private func setupNetworking() {
        #if LOCAL_SERVER
        Endpoint.config.scheme = "http"
        Endpoint.config.host = "localhost"
        Endpoint.config.port = 3000
        #else
        Endpoint.config.scheme = "https"
        Endpoint.config.host = Keys.hostURL
        #endif

        if let apiVersion = Endpoint.apiVersion {
            Endpoint.config.commonPath = "/api/v\(apiVersion)"
        }
    }
    
    private func getPollSessions(with role: UserRole) -> Future<Response<[Session]>> {
        return networking(Endpoint.getPollSessions(with: role)).decode()
    }
    
    internal func signIn() {
        if true {
            
            let significantEvents: Int = UserDefaults.standard.integer(forKey: Identifiers.significantEventsIdentifier)
            UserDefaults.standard.set(significantEvents + 2, forKey: Identifiers.significantEventsIdentifier)
            
            var joinedSessions = [Session]()
            var createdSessions = [Session]()
            
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            dispatchGroup.enter()
            getPollSessions(with: .member).observe { memberResult in
                switch memberResult {
                case .value(let memberResponse):
                    var auxiliaryDict = [Double: Session]()
                    memberResponse.data.forEach { session in
                        if let updatedAt = session.updatedAt, let latestActivityTimestamp = Double(updatedAt) {
                            auxiliaryDict[latestActivityTimestamp] = Session(id: session.id, name: session.name, code: session.code, latestActivity: getLatestActivity(latestActivityTimestamp: latestActivityTimestamp, code: session.code, role: .member), isLive: session.isLive)
                        }
                    }
                    auxiliaryDict.keys.sorted().forEach { time in
                        guard let joinedSession = auxiliaryDict[time] else { return }
                        joinedSessions.append(joinedSession)
                    }
                case .error(let memberError):
                    print(memberError)
                }
                dispatchGroup.leave()
            }
            getPollSessions(with: .admin).observe { adminResult in
                switch adminResult {
                case .value(let adminResponse):
                    var auxiliaryDict = [Double: Session]()
                    adminResponse.data.forEach { session in
                        if let updatedAt = session.updatedAt, let latestActivityTimestamp = Double(updatedAt) {
                            auxiliaryDict[latestActivityTimestamp] = Session(id: session.id, name: session.name, code: session.code, latestActivity: getLatestActivity(latestActivityTimestamp: latestActivityTimestamp, code: session.code, role: .admin), isLive: session.isLive)
                        }
                    }
                    auxiliaryDict.keys.sorted().forEach { time in
                        guard let createdSession = auxiliaryDict[time] else { return }
                        createdSessions.append(createdSession)
                    }
                case .error(let adminError):
                    print(adminError)
                }
                dispatchGroup.leave()
            }
            dispatchGroup.notify(queue: .main, execute: {
                //guard let `self` = self else { return }
                DispatchQueue.main.async {
                    let pollsViewController = PollsViewController(joinedSessions: joinedSessions, createdSessions: createdSessions)
                    self.pollsNavigationController.pushViewController(pollsViewController, animated: !self.didSignInSilently)
                }
            })
            
        } else if didSignInSilently {
            self.pollsNavigationController.pushViewController(NoInternetViewController(), animated: false)
        }
    }
    
    internal func logout() {
        //GIDSignIn.sharedInstance().signOut()
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
