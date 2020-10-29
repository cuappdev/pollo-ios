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
    let cornellColor: UIColor = UIColor(red: 179.0 / 255.0, green: 27.0 / 255.0, blue: 27.0 / 255.0, alpha: 1.0)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = cornellColor
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
