//
//  EndSessionViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 2/6/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class EndSessionViewController: UIViewController {
    
    var session: Session!
    var isOldPoll: Bool!
    var dismissController: UIViewController!
    var cancelButton: UIButton!
    var confirmationLabel: UILabel!
    var sidenoteLabel: UILabel!
    var sessionView: UIView!
    var nameSessionTextField: UITextField!
    var saveButton: UIButton!
    var endSessionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func endSession() {
        // Emit socket messsage to end question
        session.socket.emit("server/question/end", with: [])
        
        // Get current poll object
        let currentPoll = decodeObjForKey(key: "currentPoll") as! Poll
        if let name = nameSessionTextField.text {
            if (name != "") {
                print("saving poll")
                // Emit socket message for users to save poll
                session.socket.emit("server/poll/save", with: [])
                // End poll
                endPoll(pollId: currentPoll.id, save: true)
                // Update poll name
                updateSavePoll(pollId: currentPoll.id, name: name)
            } else {
                print("ending poll without saving")
                // End poll
                endPoll(pollId: currentPoll.id, save: false)
            }
        } else {
            print("ending poll without saving")
            // End poll
            endPoll(pollId: currentPoll.id, save: false)
        }
        cancel()
        self.dismissController.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: Update poll with given name and then save it to UserDefaults
    func updateSavePoll(pollId: Int, name: String) {
        UpdatePoll(id: pollId, name: name).make()
            .then { poll -> Void in
                self.encodeObjForKey(obj: poll, key: "currentPoll")
                self.savePoll(poll: poll)
            }.catch { error -> Void in
                print(error)
            }
    }
    
    // MARK: Save poll to UserDefaults
    func savePoll(poll: Poll) {
        if (UserDefaults.standard.value(forKey: "savedPolls") == nil) {
            var polls: [Poll] = [poll]
            encodeObjForKey(obj: polls, key: "savedPolls")
        } else {
            var polls = decodeObjForKey(key: "savedPolls") as! [Poll]
            print("is old poll is: \(isOldPoll)")
            if (isOldPoll) {
                // Get index of old poll and update it in savedPolls array
                var pollIndex = -1
                for (index, p) in polls.enumerated() {
                    if (p.code == poll.code) {
                        pollIndex = index
                        break
                    }
                }
                polls[pollIndex] = poll
            } else {
                polls.append(poll)
            }
            encodeObjForKey(obj: polls, key: "savedPolls")
        }
    }
    
    // MARK: End poll
    func endPoll(pollId: Int, save: Bool) {
        EndPoll(id: pollId, save: save).make()
            .then { Void -> Void in
                print("ended poll")
            }.catch { error -> Void in
                print(error)
            }
    }
    
    func setupViews() {
        cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.clickerGreen, for: .normal)
        cancelButton.titleLabel?.font = UIFont._16SemiboldFont
        cancelButton.backgroundColor = .white
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        confirmationLabel = UILabel()
        confirmationLabel.text = "Are you sure you want to end session?"
        confirmationLabel.textColor = .clickerBlack
        confirmationLabel.font = UIFont._18SemiboldFont
        view.addSubview(confirmationLabel)
        
        sidenoteLabel = UILabel()
        sidenoteLabel.text = "This will close any open polls and cause any remaining participants to exit."
        sidenoteLabel.textColor = .clickerBlack
        sidenoteLabel.font = UIFont.systemFont(ofSize: 12)
        sidenoteLabel.lineBreakMode = .byWordWrapping
        sidenoteLabel.numberOfLines = 0
        view.addSubview(sidenoteLabel)
        
        sessionView = UIView()
        sessionView.backgroundColor = .clickerBackground
        sessionView.layer.cornerRadius = 8
        sessionView.layer.borderColor = UIColor(red: 232/255, green: 233/255, blue: 236/255, alpha: 1.0).cgColor
        sessionView.layer.borderWidth = 0.5
        view.addSubview(sessionView)
        
        saveButton = UIButton()
        saveButton.setImage(#imageLiteral(resourceName: "save"), for: .normal)
        saveButton.backgroundColor = .clear
        sessionView.addSubview(saveButton)
        
        nameSessionTextField = UITextField()
        nameSessionTextField.placeholder = "Enter a name to save this session"
        nameSessionTextField.font = UIFont._16RegularFont
        nameSessionTextField.borderStyle = .none
        nameSessionTextField.backgroundColor = .clear
        nameSessionTextField.layer.sublayerTransform = CATransform3DMakeTranslation(18, 0, 0)
        let currentPoll = decodeObjForKey(key: "currentPoll") as! Poll
        if (currentPoll.name != "") {
            nameSessionTextField.text = currentPoll.name
        }
        sessionView.addSubview(nameSessionTextField)
        
        endSessionButton = UIButton()
        endSessionButton.setTitle("Yes, end session", for: .normal)
        endSessionButton.setTitleColor(.white, for: .normal)
        endSessionButton.backgroundColor = .clickerOrange
        endSessionButton.layer.cornerRadius = 8
        endSessionButton.addTarget(self, action: #selector(endSession), for: .touchUpInside)
        view.addSubview(endSessionButton)
    }
    
    func setupConstraints() {
        cancelButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 60, height: 20))
            make.left.equalToSuperview().offset(18)
            make.top.equalToSuperview().offset(18)
        }
        
        confirmationLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
            make.height.equalTo(24)
            make.top.equalTo(cancelButton.snp.bottom).offset(24)
        }
        
        sidenoteLabel.snp.makeConstraints { make in
            make.width.equalTo(confirmationLabel.snp.width)
            make.height.equalTo(32)
            make.top.equalTo(confirmationLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        sessionView.snp.makeConstraints { make in
            make.width.equalTo(confirmationLabel.snp.width)
            make.height.equalTo(55)
            make.top.equalTo(sidenoteLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
        }
        
        nameSessionTextField.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(saveButton.snp.left)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        endSessionButton.snp.makeConstraints { make in
            make.width.equalTo(confirmationLabel.snp.width)
            make.height.equalTo(55)
            make.bottom.equalToSuperview().offset(-17.5)
            make.centerX.equalToSuperview()
        }
    }
}
