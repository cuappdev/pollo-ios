//
//  HomeViewController.swift
//  Clicker
//
//  Created by Keivan Shahida on 9/24/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var joinLabel: UILabel!
    var joinView: UIView!
    var sessionTextField: UITextField!
    var joinButton: UIButton!
    var whiteView: UIView!
    var createPollButton: UIButton!
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clickerBackground
        setupViews()
        setupConstraints()
       
    }
    
    func setupViews() {
        joinLabel = UILabel()
        joinLabel.text = "Join A Session"
        joinLabel.font = UIFont._16SemiboldFont
        joinLabel.textColor = .clickerMediumGray
        view.addSubview(joinLabel)
        
        joinView = UIView()
        joinView.layer.cornerRadius = 8
        joinView.layer.masksToBounds = true
        view.addSubview(joinView)
        
        sessionTextField = UITextField()
        let sessionAttributedString = NSMutableAttributedString(string: "Enter session code")
        sessionAttributedString.addAttribute(.font, value: UIFont._16RegularFont, range: NSRange(location: 0, length: sessionAttributedString.length))
        sessionTextField.attributedPlaceholder = sessionAttributedString
        sessionTextField.layer.sublayerTransform = CATransform3DMakeTranslation(18, 0, 0)
        joinView.addSubview(sessionTextField)
        
        joinButton = UIButton()
        joinButton.setTitle("Join", for: .normal)
        joinButton.titleLabel?.font = UIFont._18MediumFont
        joinButton.setTitleColor(.clickerDarkGray, for: .normal)
        joinButton.backgroundColor = .clickerLightGray
        joinView.addSubview(joinButton)
    }
    
    func setupConstraints() {
        joinLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.frame.width * 0.8066666667, height: view.frame.height * 0.02848575712))
            make.left.equalToSuperview().offset(view.frame.width * 0.048)
            make.top.equalToSuperview().offset(view.frame.height * 0.1101949025)
        }
        
        joinView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(view.frame.width * 0.048)
            make.right.equalToSuperview().offset(view.frame.width * 0.048 * -1)
            make.top.equalTo(joinLabel.snp.bottom).offset(view.frame.height * 0.01499250375)
            make.height.equalTo(view.frame.height * 0.08245877061)
        }
        
        sessionTextField.snp.makeConstraints { make in
            make.width.equalTo(joinView.snp.width).multipliedBy(0.75)
            make.height.equalTo(joinView.snp.height)
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        joinButton.snp.makeConstraints{ make in
            make.left.equalTo(sessionTextField.snp.right)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}
