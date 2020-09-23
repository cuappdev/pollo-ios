//
//  LoginViewController.swift
//  Pollo
//
//  Created by Kevin Chan on 3/20/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.

import SnapKit
import UIKit
import WebKit

class LoginViewController: UIViewController {
    
    let appNameLabel = UILabel()
    let gradient = CAGradientLayer()
    let pronunciationLabel = UILabel()
    let ssoButtonView = UIView()
    let ssoButtonImageView = UIImageView()
    let ssoButtonTitle = UILabel()
    var ssoWebView: WKWebView!
    let welcomeLabel = UILabel()
    
    // MARK: - Constraints
    let appNameLabelHeight: CGFloat = 71.5
    let appNameLabelOffset: CGFloat = 5.0
    let pronunciationLabelHeight: CGFloat = 19.0
    let pronunciationLabelTopOffset: CGFloat = 14.5
    let ssoButtonCornerRadius: CGFloat = 4.0
    let ssoButtonHeight: CGFloat = 39.0
    let ssoButtonTopOffset: CGFloat = 36.0
    let ssoButtonWidth: CGFloat = 200.0
    let ssoButtonImageViewVerticalPadding: CGFloat = 7.0
    let ssoButtonImageViewLeadingPadding: CGFloat = 6.0
    let ssoButtonTitleVerticalPadding: CGFloat = 11.0
    let welcomeLabelHeight: CGFloat = 31.5
    let welcomeLabelTopScaleFactor: CGFloat = 0.3
    let welcomeLabelWidth: CGFloat = 249.5
    
    // MARK: - Constants
    let appNameLabelText: String = "Pollo"
    let pronunciationLabelText: String = "\"Poh-loh\""
    let welcomeLabelText: String = "Welcome to"
    let ssoButtonTitleText: String = "Sign in with Cornell SSO"
    let ssoLogoImage: UIImage = UIImage(named: "cornell_logo")!
    let sessionTokenHandlerName: String = "sessionTokenHandler"
    let ssoEndpoint: String = ":-)"
    
    // MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradient.colors = [UIColor.bluishGreen.cgColor, UIColor.aquaMarine.cgColor]
        gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
        
        welcomeLabel.text = welcomeLabelText
        welcomeLabel.font = ._26MediumFont
        welcomeLabel.textColor = .white
        welcomeLabel.adjustsFontSizeToFitWidth = true
        welcomeLabel.textAlignment = .center
        view.addSubview(welcomeLabel)
        
        appNameLabel.text = appNameLabelText
        appNameLabel.font = ._60HeavyFont
        appNameLabel.textColor = .white
        appNameLabel.adjustsFontSizeToFitWidth = true
        appNameLabel.textAlignment = .center
        view.addSubview(appNameLabel)
        
        pronunciationLabel.text = pronunciationLabelText
        pronunciationLabel.font = ._18MediumItalicFont
        pronunciationLabel.textColor = .white
        pronunciationLabel.adjustsFontSizeToFitWidth = true
        pronunciationLabel.textAlignment = .center
        view.addSubview(pronunciationLabel)
        
        ssoButtonView.backgroundColor = .white
        ssoButtonView.layer.cornerRadius = ssoButtonCornerRadius
        ssoButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSSO)))
        view.addSubview(ssoButtonView)
        
        ssoButtonImageView.image = ssoLogoImage.withRenderingMode(.alwaysTemplate)
        ssoButtonImageView.tintColor = .mediumGrey
        ssoButtonImageView.contentMode = .scaleAspectFill
        ssoButtonView.addSubview(ssoButtonImageView)
        
        ssoButtonTitle.text = ssoButtonTitleText
        ssoButtonTitle.textAlignment = .center
        ssoButtonTitle.font = ._14MediumFont
        ssoButtonTitle.textColor = .mediumGrey
        ssoButtonView.addSubview(ssoButtonTitle)
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(self, name: sessionTokenHandlerName)
        ssoWebView = WKWebView(frame: view.frame, configuration: configuration)
        ssoWebView.isHidden = true
        view.addSubview(ssoWebView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        welcomeLabel.snp.makeConstraints { make in
            make.width.equalTo(welcomeLabelWidth)
            make.height.equalTo(welcomeLabelHeight)
            make.top.equalToSuperview().offset(view.frame.height * welcomeLabelTopScaleFactor)
            make.centerX.equalToSuperview()
        }
        appNameLabel.snp.makeConstraints { make in
            make.width.equalTo(welcomeLabel.snp.width)
            make.height.equalTo(appNameLabelHeight)
            make.top.equalTo(welcomeLabel.snp.bottom).inset(appNameLabelOffset)
            make.centerX.equalToSuperview()
        }
        pronunciationLabel.snp.makeConstraints { make in
            make.width.equalTo(welcomeLabel.snp.width)
            make.height.equalTo(pronunciationLabelHeight)
            make.top.equalTo(appNameLabel.snp.bottom).offset(pronunciationLabelTopOffset)
            make.centerX.equalToSuperview()
        }
        
        ssoButtonView.snp.makeConstraints { make in
            make.width.equalTo(ssoButtonWidth)
            make.height.equalTo(ssoButtonHeight)
            make.top.equalTo(pronunciationLabel.snp.bottom).offset(ssoButtonTopOffset)
            make.centerX.equalToSuperview()
        }
        
        ssoButtonImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(ssoButtonImageViewVerticalPadding)
            make.bottom.equalToSuperview().inset(ssoButtonImageViewVerticalPadding)
            make.leading.equalToSuperview().offset(ssoButtonImageViewLeadingPadding)
            make.width.equalTo(ssoButtonImageView.snp.height)
        }
        
        ssoButtonTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(ssoButtonTitleVerticalPadding)
            make.bottom.equalToSuperview().inset(ssoButtonTitleVerticalPadding)
            make.leading.equalTo(ssoButtonImageView.snp.trailing)
            make.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    @objc private func openSSO() {
        if let unwrappedURL = URL(string: ssoEndpoint) {
            ssoWebView.isHidden = false
            ssoWebView.load(URLRequest(url: unwrappedURL))
        }/*
        let vc = UIViewController()
        vc.view = ssoWebView
        present(vc, animated: true) {
            if let unwrappedURL = URL(string: self.ssoEndpoint) {
                self.ssoWebView.load(URLRequest(url: unwrappedURL))
            }
        }*/
    }
}

extension LoginViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == sessionTokenHandlerName {
            print("Message successfully received")
            guard let dict = message.body as? [String: AnyObject],
                let accessToken = dict["accessToken"] as? String,
                let isActive = dict["isActive"] as? Bool,
                let refreshToken = dict["refreshToken"] as? String,
                let sessionExpiration = dict["sessionExpiration"] as? Int
                else { return }
            print("Message successfully parsed")
            print("Access Token: \(accessToken)")
            print("isActive: \(isActive)")
            print("Refresh Token: \(refreshToken)")
            print("Session Expiration: \(sessionExpiration)")
        }
    }
    
}
