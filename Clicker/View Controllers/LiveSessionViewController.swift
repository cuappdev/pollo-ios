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
        getPollPort()
        setupNavBar()
        setConstraints()
        // pending()
    }
    
    // MARK: - CONTAINER VIEW
    func updateContainerVC(currentState: CurrentState? = nil){
        removeChildViewControllers()
        if let cs = currentState {
            let userResultsVC = UserResultsViewController()
            userResultsVC.question = question
            userResultsVC.currentState = cs
            containerViewController = userResultsVC
            addChildViewController(userResultsVC)
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
    
    func pending(){
        let pendingViewController = PendingViewController()
        containerViewController = pendingViewController
        addChildViewController(containerViewController)
        containerView.addSubview(containerViewController.view)
        containerViewController.view.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        containerViewController.didMove(toParentViewController: self)
    }
    
    func removeChildViewControllers() {
        for vc in childViewControllers {
            vc.willMove(toParentViewController: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParentViewController()
        }
    }
    
    // MARK: - CONSTRAINTS
    func setConstraints() {
        containerView.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
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
    
    // MARK: - Get port
    func getPollPort() {
        print("poll id: \(poll.id), \(poll.code)")
        GetPollPorts(id: poll.id).make()
            .then { port -> Void in
                if let p = port {
                    self.session = Session(id: p, userType: "user", delegate: self)
                    self.checkQuestionAtPort(port: p)
                }
                print("got poll port: \(port)")
            }.catch { error -> Void in
                print(error)
                print("failed to get poll port")
            }
    }
    
    // MARK: - Check for live question at port
    func checkQuestionAtPort(port: Int) {
        GetQuestionAtPort(port: port).make()
            .then { question -> Void in
                self.question = question
                self.updateContainerVC()
            }.catch {error -> Void in
                self.pending()
                print(error)
            }
    }
    
    // MARK: - SESSION
    @objc func endSession() {
        // Disconnect user from socket
        session.socket.disconnect()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: Save poll to adminSavedPolls in UserDefaults
    func saveUserPoll(poll: Poll) {
        if (UserDefaults.standard.value(forKey: "userSavedPolls") == nil) {
            var polls: [Poll] = [poll]
            encodeObjForKey(obj: polls, key: "userSavedPolls")
        } else {
            var polls = decodeObjForKey(key: "userSavedPolls") as! [Poll]
            // Check if poll has already been saved before
            var pollIndex = -1
            for (index, p) in polls.enumerated() {
                if (p.code == poll.code) {
                    pollIndex = index
                    break
                }
            }
            if (pollIndex != -1) {
                polls[pollIndex] = poll
            } else {
                polls.append(poll)
            }
            encodeObjForKey(obj: polls, key: "userSavedPolls")
        }
    }
    
    // MARK - Socket methods
    func sessionConnected() {
    }
    
    func sessionDisconnected() {
    }
    
    func questionStarted(_ question: Question) {
        print("detected question: \(question)")
        self.question = question
        updateContainerVC()
    }
    
    func questionEnded(_ question: Question) {
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
}
