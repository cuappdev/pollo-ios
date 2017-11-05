//
//  MultipleChoiceViewController.swift
//  Clicker
//
//  Created by Keivan Shahida on 10/29/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

class MultipleChoiceViewController: UIViewController, SessionDelegate {

    var question: Question?
    var courseLabel: UILabel!
    var timeLabel: UILabel!
    var questionLabel: UILabel!
    var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 247/255, green: 249/255, blue: 250/255, alpha: 1.0)
        
        setupSubviews()
    }
    
    func setupSubviews() {
        courseLabel = UILabel()
        courseLabel.text = "ASTRO 1101"
        
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
    }
    
    func beginQuestion(_ question: Question) {
        print("begin question")
    }
    
    func endQuestion() {
        print("end question")
    }
    
    func postResponses(_ answers: [Answer]) {
        print("post responses")
    }
    
    func joinLecture(_ lectureId: String) {
        // socket.emit("join_lecture", lectureId)
    }
    
    func sendResponse(_ answer: Answer) {
        //not letting us access Session
        // socket.emit("send_response", answer)
    }
}
