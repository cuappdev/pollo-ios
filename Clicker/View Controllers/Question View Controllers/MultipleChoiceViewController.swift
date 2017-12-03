//
//  MultipleChoiceViewController.swift
//  Clicker
//
//  Created by Keivan Shahida on 10/29/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit
import SocketIO

class MultipleChoiceViewController: UIViewController, SessionDelegate {
    
    var question: Question!
    var course: Course?
    var courseLabel: UILabel!
    var timeLabel: UILabel!
    var questionLabel: UILabel!
    var submitButton: UIButton!
    var answerButtons = [AnswerButton]()
    
    var selectedIndex: Int = -1
    var timer: Timer!
    
    var session: Session?
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerBackground
        
        setupSubviews()
        runTimer()
    }
    
    // MARK: - VIEWS
    func setupSubviews() {
        courseLabel = UILabel()
        courseLabel.text = course?.name
        courseLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        courseLabel.textAlignment = .left
        view.addSubview(courseLabel)
        
        timeLabel = UILabel()
        timeLabel.text = "Timer 00:59"
        timeLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        timeLabel.textColor = .clickerMediumGray
        timeLabel.textAlignment = .right
        view.addSubview(timeLabel)
        
        questionLabel = UILabel()
        if let questionText = question?.text {
            questionLabel.text = questionText
        }
        questionLabel.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        questionLabel.numberOfLines = 2
        questionLabel.textAlignment = .left
        questionLabel.lineBreakMode = .byWordWrapping
        view.addSubview(questionLabel)
        
        for option in (question?.options)! {
            let optionButton = AnswerButton(frame: .zero, description: option.description)
            optionButton.tag = answerButtons.count
            optionButton.addTarget(self, action: #selector(optionSelected), for: .touchUpInside)
            view.addSubview(optionButton)
            answerButtons.append(optionButton)
            if answerButtons.count == 1 {
                optionButton.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(18)
                    make.right.equalToSuperview().offset(-18)
                    make.top.equalTo(questionLabel.snp.bottom).offset(36)
                    make.height.equalTo(55)
                }
            } else {
                optionButton.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(18)
                    make.right.equalToSuperview().offset(-18)
                    make.top.equalTo(answerButtons[answerButtons.count - 2].snp.bottom).offset(5)
                    make.height.equalTo(55)
                }
            }
        }
        
        submitButton = UIButton(frame: .zero)
        submitButton.layer.cornerRadius = 8
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = .clickerLightGray
        submitButton.setTitleColor(.clickerDarkGray, for: .normal)
        submitButton.addTarget(self, action: #selector(submitResponse), for: .touchUpInside)
        view.addSubview(submitButton)
        
        setConstraints()
    }
    
    // MARK: - CONTRAINTS
    func setConstraints() {
        
        courseLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.top.equalToSuperview().offset(82)
            make.width.equalTo(view.frame.width).multipliedBy(0.2)
            make.height.equalTo(16)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-18)
            make.top.equalToSuperview().offset(82)
            make.width.equalTo(view.frame.width).multipliedBy(0.2)
            make.height.equalTo(16)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.top.equalTo(courseLabel.snp.bottom).offset(18)
            make.width.equalTo(view.frame.width).multipliedBy(0.8)
            make.height.equalTo(70)
        }
        
        submitButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
            make.top.equalTo(answerButtons[answerButtons.count - 1].snp.bottom).offset(36)
            make.height.equalTo(55)
        }
    }
    
    // MARK: - TIMER
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimeLabel() {
        let colonIndex = timeLabel.text?.index(of: ":")
        let index = timeLabel.text?.index(colonIndex!, offsetBy: 1)
        if let i = index {
            let sec = Int((timeLabel.text?.substring(from: i))!)
            if sec == 0 {
                timer.invalidate()
            } else if sec! <= 10 {
                timeLabel.text = "Timer 00:0\(sec! - 1)"
            } else {
                timeLabel.text = "Timer 00:\(sec! - 1)"
            }
        }
    }
    
    // MARK: - RESPONDING
    @objc func submitResponse() {
        if selectedIndex == -1 {
            return
        }
        sendingResponse()
        let alert = UIAlertController(title: "Submitted", message: "Your response has been recorded.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendingResponse() {
        if selectedIndex == -1 {
            return
        }
        var response = ""
        switch selectedIndex {
        case 0:
            response = "A"
        case 1:
            response = "B"
        case 2:
            response = "C"
        case 3:
            response = "D"
        default:
            response = ""
        }
        guard let qid = Int(question.id) else {
            print("could not convert question id to int")
            return
        }
        let data: [String:Any] = [
            "answerer": 1,                  // userID
            "question": Int(question.id),   // questionID
            "data": response                // the response
        ]
        self.session?.socket.emit("server/question/respond", with: [data])
    }
    
    @objc func optionSelected(sender: UIButton) {
        if selectedIndex != -1 {
            answerButtons[selectedIndex].setTitleColor(.black, for: .normal)
        }
        selectedIndex = sender.tag
        answerButtons[selectedIndex].setTitleColor(.clickerBlue, for: .normal)
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
    
    func endQuestion(_ question: Question) {
        print("DETECTED QUESTION END IN MC CONTROLLER")
        sendingResponse()
        self.removeFromParentViewController()
    }
    
    func postResponses(_ answers: [Answer]) {
        print("post responses")
    }
    
    func sendResponse(_ answer: Answer) {
        // socket.emit("send_response", answer)
    }
}
