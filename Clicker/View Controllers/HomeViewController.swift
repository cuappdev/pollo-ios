//
//  HomeViewController.swift
//  Clicker
//
//  Created by Keivan Shahida on 9/24/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    
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
    
    // MARK: Generate poll code
    func getNewPollCode() {
        GeneratePollCode().make()
            .then{ code -> Void in
                UserDefaults.standard.setValue(code, forKey: "pollCode")
            }.catch { error -> Void in
                print(error)
                return
        }
        
    }
    
    @objc func beganTypingCode(_ textField: UITextField) {
        if let text = textField.text {
            if text != "" {
                joinButton.backgroundColor = .clickerGreen
                joinButton.setTitleColor(.white, for: .normal)
            } else {
                joinButton.backgroundColor = .clickerLightGray
                joinButton.setTitleColor(.clickerDarkGray, for: .normal)
            }
        } else {
            joinButton.backgroundColor = .clickerLightGray
            joinButton.setTitleColor(.clickerDarkGray, for: .normal)
        }
    }
    
    @objc func createNewPoll() {
        // Make sure poll code exists
        if (UserDefaults.standard.object(forKey: "pollCode") == nil) {
            GeneratePollCode().make()
                .then{ code -> Void in
                    UserDefaults.standard.setValue(code, forKey: "pollCode")
                    let createQuestionVC = CreateQuestionViewController()
                    self.navigationController?.pushViewController(createQuestionVC, animated: true)
                }.catch { error -> Void in
                    print(error)
                    return
            }
        } else {
            let createQuestionVC = CreateQuestionViewController()
            self.navigationController?.pushViewController(createQuestionVC, animated: true)
        }
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
        sessionTextField.addTarget(self, action: #selector(beganTypingCode), for: .editingChanged)
        sessionTextField.backgroundColor = .white
        joinView.addSubview(sessionTextField)
        
        joinButton = UIButton()
        joinButton.setTitle("Join", for: .normal)
        joinButton.titleLabel?.font = UIFont._18MediumFont
        joinButton.setTitleColor(.clickerDarkGray, for: .normal)
        joinButton.backgroundColor = .clickerLightGray
        joinView.addSubview(joinButton)
        
        whiteView = UIView()
        whiteView.backgroundColor = .white
        view.addSubview(whiteView)
        
        createPollButton = UIButton()
        createPollButton.setTitle("Create New Poll", for: .normal)
        createPollButton.setTitleColor(.white, for: .normal)
        createPollButton.titleLabel?.font = UIFont._18MediumFont
        createPollButton.backgroundColor = .clickerGreen
        createPollButton.layer.cornerRadius = 8
        createPollButton.addTarget(self, action: #selector(createNewPoll), for: .touchUpInside)
        whiteView.addSubview(createPollButton)
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
        
        whiteView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(view.frame.height * 0.1364317841)
        }
        
        createPollButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: view.frame.width * 0.904, height: view.frame.height * 0.08245877061))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        // Get new poll code if needed
        getNewPollCode()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show navigation bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Keyboard
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
