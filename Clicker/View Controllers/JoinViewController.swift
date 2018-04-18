//
//  JoinViewController.swift
//  Clicker
//
//  Created by eoin on 4/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//
import UIKit

class JoinViewController: UITabBarController {
    
    var joinTextField: UITextField!
    var joinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerDeepBlack
        
        setupViews()
        setupConstraints()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // JOIN BUTTON PRESSED
    @objc func joinBtnPressed() {
        if let code = joinTextField.text {
            if code != "" {
                StartSession(code: code).make()
                    .done { session in
                        let socket = Socket(id: Int(session.id)!, userType: "user")
                        let blackAskVC = BlackAskController()
                        self.navigationController?.pushViewController(blackAskVC, animated: true)
                        self.navigationController?.setNavigationBarHidden(false, animated: true)
                        self.tabBarController?.tabBar.isHidden = true
                    }.catch { error in
                        print(error)
                    }
            }
        }
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        joinTextField = UITextField()
        joinTextField.backgroundColor = .white
        view.addSubview(joinTextField)
        
        joinButton = UIButton()
        joinButton.setTitle("Join", for: .normal)
        joinButton.addTarget(self, action: #selector(joinBtnPressed), for: .touchUpInside)
        view.addSubview(joinButton)
    }
    
    func setupConstraints() {
        joinTextField.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 50))
            make.center.equalToSuperview()
        }
        
        joinButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 75, height: 50))
            make.top.equalTo(joinTextField.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
    }
    
}
