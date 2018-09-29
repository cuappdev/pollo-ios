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
    let navBarTitle = "Submit Feedback"
    let feedbackFormUrl = "https://goo.gl/forms/9izY3GCRWoA1Fe8e2"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = navBarTitle
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        view.backgroundColor = .white
        setupWebView()
    }
    
    // WEBVIEW
    func setupWebView() {
        let url = URL(string: feedbackFormUrl)
        let request = URLRequest(url: url!)
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.load(request)
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barTintColor = .clickerBlack1
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
}
