//
//  PendingViewController.swift
//  Clicker
//
//  Created by Keivan Shahida on 10/29/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

class PendingViewController: UIViewController, SessionDelegate {
    
    var poll: Poll!
    var codeBarButtonItem: UIBarButtonItem!
    var endSessionBarButtonItem: UIBarButtonItem!
    var pendingLabel: UILabel!
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerBackground
        
        setupNavBar()
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
    
    // MARK - Setup views
    func setupNavBar() {
        UINavigationBar.appearance().barTintColor = .clickerGreen
        
        let codeLabel = UILabel()
        let codeAttributedString = NSMutableAttributedString(string: "SESSION CODE: \(poll.code ?? "------")")
        codeAttributedString.addAttribute(.font, value: UIFont._16RegularFont, range: NSRange(location: 0, length: 13))
        codeAttributedString.addAttribute(.font, value: UIFont._16MediumFont, range: NSRange(location: 13, length: codeAttributedString.length - 13))
        codeLabel.attributedText = codeAttributedString
        codeLabel.textColor = .white
        codeLabel.backgroundColor = .clear
        codeBarButtonItem = UIBarButtonItem(customView: codeLabel)
        self.navigationItem.leftBarButtonItem = codeBarButtonItem
        
        let endSessionButton = UIButton()
        let endSessionAttributedString = NSMutableAttributedString(string: "Exit Session")
        endSessionAttributedString.addAttribute(.font, value: UIFont._16SemiboldFont, range: NSRange(location: 0, length: endSessionAttributedString.length))
        endSessionAttributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: endSessionAttributedString.length))
        endSessionButton.setAttributedTitle(endSessionAttributedString, for: .normal)
        endSessionButton.backgroundColor = .clear
        endSessionButton.addTarget(self, action: #selector(endSession), for: .touchUpInside)
        endSessionBarButtonItem = UIBarButtonItem(customView: endSessionButton)
        self.navigationItem.rightBarButtonItem = endSessionBarButtonItem
    }
    
    // MARK: - SESSION
    @objc func endSession() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK - Socket methods
    func sessionConnected() {
        <#code#>
    }
    
    func sessionDisconnected() {
        <#code#>
    }
    
    func questionStarted(_ question: Question) {
        <#code#>
    }
    
    func questionEnded(_ question: Question) {
        <#code#>
    }
    
    func receivedResults(_ currentState: CurrentState) {
        <#code#>
    }
    
    func savePoll(_ poll: Poll) {
        <#code#>
    }
    
    func updatedTally(_ currentState: CurrentState) {
        <#code#>
    }
}
