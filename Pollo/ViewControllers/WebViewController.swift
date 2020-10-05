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

    let sessionTokenHandlerName: String = "sessionTokenHandler"
    var ssoWebView: WKWebView!
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, User.userSession != nil else { return }
        appDelegate.signIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(self, name: sessionTokenHandlerName)
        ssoWebView = WKWebView(frame: view.frame, configuration: configuration)
        view.addSubview(ssoWebView)
        
        if let url = Endpoint.getSSOUrl(provider: "cornell").url {
            let request = URLRequest(url: url)
            ssoWebView.load(request)
        }
    }
}

extension WebViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name != sessionTokenHandlerName { return }
        guard let dict = message.body as? [String: AnyObject],
            let accessToken = dict["accessToken"] as? String,
            let isActive = dict["isActive"] as? Bool,
            let refreshToken = dict["refreshToken"] as? String,
            let sessionExpiration = dict["sessionExpiration"] as? String
            else { return }
        User.userSession = UserSession(accessToken: accessToken, refreshToken: refreshToken, sessionExpiration: sessionExpiration, isActive: isActive)
        navigationController?.popViewController(animated: true)
    }
}
