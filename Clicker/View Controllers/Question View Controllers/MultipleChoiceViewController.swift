//
//  MultipleChoiceViewController.swift
//  Clicker
//
//  Created by Keivan Shahida on 10/29/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class MultipleChoiceViewController: UIViewController, SessionDelegate {

    var question: Question?
    var courseLabel: UILabel!
    var timeLabel: UILabel!
    var questionLabel: UILabel!
    var submitButton: UIButton!
    var answerButtons = [AnswerButton]()
    
    var selectedIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerBackground
        setupSubviews()
    }
    
    func setupSubviews() {
        courseLabel = UILabel()
        courseLabel.text = "ASTRO 1101"
        courseLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        courseLabel.textAlignment = .left
        view.addSubview(courseLabel)
        
        courseLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.top.equalToSuperview().offset(82)
            make.width.equalTo(view.frame.width).multipliedBy(0.2)
            make.height.equalTo(16)
        }
        
        timeLabel = UILabel()
        timeLabel.text = "Timer 00:59"
        timeLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        timeLabel.textColor = .clickerMediumGray
        timeLabel.textAlignment = .right
        view.addSubview(timeLabel)
        
        timeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-18)
            make.top.equalToSuperview().offset(82)
            make.width.equalTo(view.frame.width).multipliedBy(0.2)
            make.height.equalTo(16)
        }
        
        questionLabel = UILabel()
        if let questionText = question?.text {
            questionLabel.text = questionText
        }
        questionLabel.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        questionLabel.numberOfLines = 2
        questionLabel.textAlignment = .left
        questionLabel.lineBreakMode = .byWordWrapping
        view.addSubview(questionLabel)
        
        questionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.top.equalTo(courseLabel.snp.bottom).offset(18)
            make.width.equalTo(view.frame.width).multipliedBy(0.8)
            make.height.equalTo(70)
        }
        
        for option in (question?.options)! {
            let optionButton = AnswerButton(frame: .zero, option: option)
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
        view.addSubview(submitButton)
        
        submitButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
            make.top.equalTo(answerButtons[answerButtons.count - 1].snp.bottom).offset(36)
            make.height.equalTo(55)
        }
        
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
