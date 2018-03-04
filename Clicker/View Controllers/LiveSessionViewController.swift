//
//  LiveSessionViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 2/19/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class LiveSessionViewController: UIViewController, SessionDelegate {
    
    var codeBarButtonItem: UIBarButtonItem!
    var endSessionBarButtonItem: UIBarButtonItem!
    var containerView: UIView!
    var containerViewController: UIViewController!
    var question: Question!
    var poll: Poll!
    var session: Session!
        
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerBackground
        
        containerView = UIView()
        view.addSubview(containerView)
        updateContainerVC(currentState: nil, pending: true)
        session = Session(id: poll.id, userType: "user", delegate: self)
        setupNavBar()
        setConstraints()
    }
    
    // MARK: - CONTAINERVIEW
    func updateContainerVC(currentState: CurrentState? = nil, pending: Bool = false){
        removeChildViewControllers()
        if let cs = currentState {
            let userResultsVC = UserResultsViewController()
            userResultsVC.pollCode = poll.code
            userResultsVC.question = question
            userResultsVC.currentState = cs
            containerViewController = userResultsVC
            addChildViewController(userResultsVC)
        } else if pending {
            let pendingViewController = PendingViewController()
            containerViewController = pendingViewController
            addChildViewController(containerViewController)
        } else {
            let answerVC = AnswerQuestionViewController()
            answerVC.question = question
            answerVC.session = session
            containerViewController = answerVC
            addChildViewController(answerVC)
        }
        containerView.addSubview(containerViewController.view)
        containerViewController.view.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        containerViewController.didMove(toParentViewController: self)
    }
    
    // Clear ChildViewControllers
    func removeChildViewControllers() {
        for vc in childViewControllers {
            vc.willMove(toParentViewController: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParentViewController()
        }
    }
    
    // MARK: - SESSION
    @objc func endSession() {
        // Disconnect user from socket
        session.socket.disconnect()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func saveUserPoll(poll: Poll) {
        print("SAVING POLL")
        guard let userSavedPolls = UserDefaults.standard.value(forKey: "userSavedPolls") else {
            print("CREATING FIRST USER SAVED POLLS")
            encodeObjForKey(obj: [poll], key: "userSavedPolls")
            return
        }
        
        var polls = decodeObjForKey(key: "userSavedPolls") as! [Poll]
        // Check if poll has already been saved before
        let pollCodes = polls.map { $0.code }
        if (pollCodes.contains(poll.code)) {
            polls[pollCodes.index(of: poll.code)!] = poll
        } else {
            polls.append(poll)
        }
        print("ADDED TO USER SAVED POLLS")
        encodeObjForKey(obj: polls, key: "userSavedPolls")
    }
    
    func sessionConnected() {}
    
    func sessionDisconnected() {
        print("popping user VC")
        endSession()
    }
    
    func questionStarted(_ question: Question) {
        print("detected question: \(question)")
        self.question = question
        updateContainerVC()
    }
    
    func questionEnded(_ question: Question) {
        removeChildViewControllers()
        updateContainerVC(currentState: nil, pending: true)
    }
    
    func receivedResults(_ currentState: CurrentState) {
        print("detected current state: \(currentState)")
        updateContainerVC(currentState: currentState)
    }
    
    func savePoll(_ poll: Poll) {
        saveUserPoll(poll: poll)
    }
    
    func updatedTally(_ currentState: CurrentState) {
    }
    
    // MARK - LAYOUT
    func setConstraints() {
        containerView.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
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
}
