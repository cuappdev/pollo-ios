//
//  FeedbackViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 3/24/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import WebKit

enum FeedbackViewControllerPresentType {
    case pollsViewController
    case settingsViewController
}

class FeedbackViewController: UIViewController, WKUIDelegate {
    
    // MARK: - View vars
    var webView: WKWebView!

    // MARK: - Data vars
    var type: FeedbackViewControllerPresentType!
    
    // MARK: - Constants
    let navBarTitle = "Submit Feedback"

    init(type: FeedbackViewControllerPresentType) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
    }

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
        let url = URL(string: Links.feedbackForm)
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
        if type == .pollsViewController {
            self.navigationController?.navigationBar.barTintColor = .clickerBlack1
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
