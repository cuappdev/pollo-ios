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
    
    // MARK: - View vars
    var webView: WKWebView!
    
    // MARK: - Constants
    let feedbackFormUrl = "https://goo.gl/forms/9izY3GCRWoA1Fe8e2"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    // WEBVIEW
    func setupWebView() {
        let url = URL(string: feedbackFormUrl)
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
