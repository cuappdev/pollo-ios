//
//  HomeViewController.swift
//  Clicker
//
//  Created by Keivan Shahida on 9/24/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, SessionDelegate {
    
    var clickerLogoImageView: UIImageView!
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Clique"
        view.backgroundColor = .clickerBlue
        setupViews()
       
    }
    
    func setupViews() {
        clickerLogoImageView = UIImageView()
        clickerLogoImageView.image = #imageLiteral(resourceName: "clickerLogoWhite")
        view.addSubview(clickerLogoImageView)
        
        clickerLogoImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 50, height: 50))
            make.center.equalToSuperview()
        }
    }
    
    
    // MARK: - SESSIONS
    func sessionConnected() {
        print("session connected")
    }
    
    func sessionDisconnected() {
        print("session disconnected")
    }
    
    func beginQuestion(_ question: Question) {
        print("begin question")        
    }
    
    func endQuestion(_ question: Question) {
        print("end question")
    }
    
    func postResponses(_ answers: [Answer]) {
        print("post responses")
    }
    
    func sendResponse(_ answer: Answer) {
        print("send responses")
    }
}
