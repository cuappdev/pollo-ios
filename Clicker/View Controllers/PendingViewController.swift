//
//  PendingViewController.swift
//  Clicker
//
//  Created by Keivan Shahida on 10/29/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

class PendingViewController: UIViewController, SocketDelegate {
    
    var pendingLabel: UILabel!
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerBackground
        
        pendingLabel = UILabel()
        pendingLabel.text = "WAITING FOR QUESTION..."
        pendingLabel.textAlignment = .center
        pendingLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        pendingLabel.textColor = .clickerBlue
        view.addSubview(pendingLabel)
        
        pendingLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(view.frame.width).multipliedBy(0.7)
            make.height.equalTo(50)
        }
    }
    
    // MARK - SESSIONS
    func sessionConnected() {}
    func sessionDisconnected() {}
    func questionStarted(_ question: Question) {}
    func questionEnded(_ question: Question) {}
    func receivedResults(_ currentState: CurrentState) {}
    func savePoll(_ poll: Poll) {}
    func updatedTally(_ currentState: CurrentState) {}
}
