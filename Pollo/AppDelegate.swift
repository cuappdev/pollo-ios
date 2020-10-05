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
        setupNavBar()
        setupNetworking()
        setupSignIn()
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
    
    private func setupNavBar() {
        pollsNavigationController.setNavigationBarHidden(true, animated: false)
        pollsNavigationController.navigationBar.barTintColor = .darkestGrey
        pollsNavigationController.navigationBar.isTranslucent = false
        
        let backImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
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
    
    private func setupSignIn() {
        let refreshToken = UserDefaults.standard.string(forKey: Identifiers.refreshTokenIdentifier)
        if let unwrappedToken = refreshToken {
            prepareRefreshedSession(with: unwrappedToken) { success in
                if success {
                    self.didSignInSilently = true
                    self.signIn()
                } else {
                    DispatchQueue.main.async {
                        let loginVC = LoginViewController()
                        self.pollsNavigationController.pushViewController(loginVC, animated: false)
                    }
                }
            }
        } else {
            let loginVC = LoginViewController()
            pollsNavigationController.pushViewController(loginVC, animated: false)
        }
    }
    
    private func userRefreshSession(with token: String) -> Future<Response<UserSession>> {
        return networking(Endpoint.userRefreshSession(with: token)).decode()
    }
    
    private func prepareRefreshedSession(with bearerToken: String, completion: @escaping (Bool) -> Void) {
        userRefreshSession(with: bearerToken).observe { sessionResult in
            switch sessionResult {
            case .value(let sessionResponse):
                let session = sessionResponse.data
                User.userSession = UserSession(accessToken: session.accessToken, refreshToken: session.refreshToken, sessionExpiration: session.sessionExpiration, isActive: session.isActive)
                completion(true)
            case .error(let sessionError):
                print(sessionError)
                completion(false)
            }
        }
    }
    
    private func setupFabric() {
        #if DEBUG
        print("[Running Pollo in debug configuration]")
        #else
        print("[Running Pollo in release configuration]")
        Crashlytics.start(withAPIKey: Keys.fabricAPIKey)
        #endif
    }
        
    internal func signIn() {
        let significantEvents: Int = UserDefaults.standard.integer(forKey: Identifiers.significantEventsIdentifier)
        UserDefaults.standard.set(significantEvents + 2, forKey: Identifiers.significantEventsIdentifier)
        
        prepareUser()
        
        var dispatchGroup: DispatchGroup? = DispatchGroup()
        var pollsRetrieved = false
        
        var joinedSessions = [Session]()
        preparePollSessions(with: .member, dispatchGroup: dispatchGroup!) { sessions in
            joinedSessions = sessions
        }
        var createdSessions = [Session]()
        preparePollSessions(with: .admin, dispatchGroup: dispatchGroup!) { sessions in
            createdSessions = sessions
        }
        
        // No internet timeout
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if !pollsRetrieved {
                dispatchGroup = nil
                self.pollsNavigationController.pushViewController(NoInternetViewController(), animated: false)
            }
        }
        // Polls successfully retrieved
        dispatchGroup?.notify(queue: .main, execute: {
            DispatchQueue.main.async {
                pollsRetrieved = true
                UserDefaults.standard.set(User.userSession?.refreshToken, forKey: Identifiers.refreshTokenIdentifier)
                let pollsViewController = PollsViewController(joinedSessions: joinedSessions, createdSessions: createdSessions)
                self.pollsNavigationController.pushViewController(pollsViewController, animated: !self.didSignInSilently)
            }
        })
    }
    
    private func getUser() -> Future<Response<GetMemberResponse>> {
        return networking(Endpoint.getMe()).decode()
    }
    
    private func prepareUser() {
        getUser().observe { userResult in
            switch userResult {
            case .value(let userResponse):
                let user = userResponse.data
                User.currentUser = User(id: user.id, name: user.name, netId: user.netID)
            case .error(let userError):
                print(userError)
            }
        }
    }
    
    private func getPollSessions(with role: UserRole) -> Future<Response<[Session]>> {
        return networking(Endpoint.getPollSessions(with: role)).decode()
    }
    
    private func preparePollSessions(with userRole: UserRole, dispatchGroup: DispatchGroup, sessionResult: @escaping ([Session]) -> Void) {
        var sessions = [Session]()
        dispatchGroup.enter()
        getPollSessions(with: userRole).observe { result in
            switch result {
            case .value(let response):
                var auxiliaryDict = [Double: Session]()
                response.data.forEach { session in
                    if let updatedAt = session.updatedAt, let latestActivityTimestamp = Double(updatedAt) {
                        auxiliaryDict[latestActivityTimestamp] = Session(
                            id: session.id,
                            name: session.name,
                            code: session.code,
                            latestActivity: getLatestActivity(
                                latestActivityTimestamp: latestActivityTimestamp,
                                code: session.code,
                                role: .admin
                            ),
                            isLive: session.isLive
                        )
                    }
                }
                auxiliaryDict.keys.sorted().forEach { time in
                    guard let session = auxiliaryDict[time] else { return }
                    sessions.append(session)
                }
                sessionResult(sessions)
            case .error(let error):
                print(error)
            }
            dispatchGroup.leave()
        }
    }
    
    internal func logout() {
        UserDefaults.standard.removeObject(forKey: Identifiers.refreshTokenIdentifier)
        User.userSession = nil
        User.currentUser = nil
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
