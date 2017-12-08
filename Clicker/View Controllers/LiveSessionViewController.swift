//
//  LiveSessionViewController.swift
//  Clicker
//
//  Created by Keivan Shahida on 10/15/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class LiveSessionViewController: UIViewController, SessionDelegate {
    
    var courseName: String!
    var liveLectureId: Int!
    var containerView: UIView?
    var containerViewController: UIViewController?
    var session: Session?
    
    var beginQuestionBarButtonItem: UIBarButtonItem!
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Live Session"
        self.view.backgroundColor = .white
        
        fetchLiveLecturePorts()
        
        containerView = UIView()
        containerView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView!)
        setConstraints()
        pending()
    }
    
    // MARK: - CONTAINER VIEW
    func updateContainerVC(question: Question){
        switch(question.type) {
            case "MULTIPLE_CHOICE":
                let multipleChoiceViewController = MultipleChoiceViewController()
                multipleChoiceViewController.question = question
                multipleChoiceViewController.courseName = courseName
                multipleChoiceViewController.session = self.session
                containerViewController = multipleChoiceViewController
                addChildViewController(containerViewController!)
                containerViewController?.view.translatesAutoresizingMaskIntoConstraints = false
                containerView?.addSubview((containerViewController?.view)!)
                containerViewController?.view.snp.makeConstraints { (make) -> Void in
                    make.left.equalToSuperview()
                    make.right.equalToSuperview()
                    make.top.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
                containerViewController?.didMove(toParentViewController: self)
            default:
                pending()
        }
    }
    
    func pending(){
        let pendingViewController = PendingViewController()
        containerViewController = pendingViewController
        addChildViewController(containerViewController!)
        containerView?.addSubview((containerViewController?.view)!)
        containerViewController?.view.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        containerViewController?.didMove(toParentViewController: self)
    }
    
    // MARK: - CONSTRAINTS
    func setConstraints() {
        containerView?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
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
        print("got question in live session")
        updateContainerVC(question: question)
    }
    
    func endQuestion(_ question: Question) {
        pending()
    }
    
    func postResponses(_ answers: [Answer]) {
        print("post responses")
    }
    
    func sendResponse(_ answer: Answer) {
        print("send response")
    }
    
    func fetchLiveLecturePorts() {
        GetLecturePorts(id: liveLectureId).make()
            .then { ports -> Void in
                for p in ports {
                    if let i = Int(p) {
                        self.session = Session(id: i, delegate: self)
                    } else {
                        return
                    }
                }
            }.catch { error -> Void in
                print(error)
        }
    }
}
