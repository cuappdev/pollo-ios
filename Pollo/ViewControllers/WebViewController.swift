//
//  WebViewController.swift
//  Pollo
//
//  Created by Gonzalo Gonzalez on 9/23/20.
//  Copyright © 2020 CornellAppDev. All rights reserved.
//

import UIKit
import FutureNova
import WebKit

class WebViewController: UIViewController {

    var ssoWebView: WKWebView!
    let sessionTokenHandlerName: String = "sessionTokenHandler"
    let ssoEndpoint: String = ":-)"
    private let networking: Networking = URLSession.shared.request
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(self, name: sessionTokenHandlerName)
        ssoWebView = WKWebView(frame: view.frame, configuration: configuration)
        view.addSubview(ssoWebView)
        
        if let url = URL(string: ssoEndpoint) {
            let request = URLRequest(url: url)
            ssoWebView.load(request)
        }
    }
}

extension WebViewController: WKScriptMessageHandler {
    
    private func getUser() -> Future<Response<GetMemberResponse>> {
        return networking(Endpoint.getMe()).decode()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name != sessionTokenHandlerName { return }
        print("Message successfully received")
        guard let dict = message.body as? [String: AnyObject],
            let accessToken = dict["accessToken"] as? String,
            let isActive = dict["isActive"] as? Bool,
            let refreshToken = dict["refreshToken"] as? String,
            let sessionExpiration = dict["sessionExpiration"] as? String
            else { return }
        print("Message successfully parsed")
        print("Access Token: \(accessToken)")
        print("isActive: \(isActive)")
        print("Refresh Token: \(refreshToken)")
        print("Session Expiration: \(sessionExpiration)")
        User.userSession = UserSession(accessToken: accessToken, refreshToken: refreshToken, sessionExpiration: sessionExpiration, isActive: isActive)
        dismiss(animated: true) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            self.getUser().observe { userResult in
                switch userResult {
                case .value(let userResponse):
                    let user = userResponse.data
                    User.currentUser = User(id: user.id, name: user.name, netId: user.netID)
                    appDelegate.signIn()
                case .error(let userError):
                    print(userError)
                }
            }
        }
    }
}
