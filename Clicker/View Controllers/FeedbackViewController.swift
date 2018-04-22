//
//  FeedbackViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 3/24/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import WebKit

class FeedbackViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    // WEBVIEW
    func setupWebView() {
        let url = URL(string: "https://www.google.com/")
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
}
