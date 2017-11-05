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
    
    var liveLecture: Lecture?
    var containerView: UIView?
    var containerViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Live Session"
        self.view.backgroundColor = .white
        
        containerView = UIView()
        containerView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView!)
        setConstraints()
    }
    
    // MARK: - CONTAINER VIEW
    
    func updateContainerVC(question: Question){
        switch(question.type) {
            case "MultipleChoiceQuestion":
                let multipleChoiceViewController = MultipleChoiceViewController()
                multipleChoiceViewController.question = question
                containerViewController = multipleChoiceViewController
                addChildViewController(containerViewController!)
                containerView?.addSubview((containerViewController?.view)!)
            default:
                pending()
        }
    }
    
    func pending(){
        containerView = UIView()
        let pendingViewController = PendingViewController()
        containerViewController = pendingViewController
        addChildViewController(containerViewController!)
        containerView?.addSubview((containerViewController?.view)!)
    }
    
    // MARK: - CONSTRAINTS
    func setConstraints() {
        containerView?.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
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
    
    func beginLecture(_ lectureId: String) {
        print("begin lecture")
    }
    
    func endLecture() {
        print("end lecture")
        DeleteLecture(id: (liveLecture?.id)!).make()
            .then{ lecture -> Void in
                self.liveLecture = nil
                self.navigationController?.popViewController(animated: true)
            }
            .catch{ error in
                print(error.localizedDescription)
        }
    }
    
    func beginQuestion(_ question: Question) {
        print("begin question")
        updateContainerVC(question: question)
    }
    
    func endQuestion() {
        print("end question")
        //socket.emit("send_response", answer)
        pending()
    }
    
    func postResponses(_ answers: [Answer]) {
        print("post responses")
    }
    
    func joinLecture(_ lectureId: String) {
        // socket.emit("join_lecture", lectureId)
    }
    
    func sendResponse(_ answer: Answer) {
        // socket.emit("send_response", answer)
    }
}
