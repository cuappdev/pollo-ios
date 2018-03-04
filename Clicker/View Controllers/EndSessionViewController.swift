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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

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
        
        // End poll and update if necessary
        let currentPoll = decodeObjForKey(key: "currentPoll") as! Poll
        if (nameSessionTextField.text?.isEmpty ?? true) {
            // End poll
            endPoll(pollId: currentPoll.id, save: false)
        } else {
            // Emit socket message for users to save poll
            self.session.socket.emit("server/poll/save", with: [])
            endPoll(pollId: currentPoll.id, save: true)
            updateSavePoll(pollId: currentPoll.id, name: nameSessionTextField.text!)
        }
        
        // Return to HomeVC
        cancel()
        self.dismissController.navigationController?.popToRootViewController(animated: true)
        // Wait a little before disconnecting socket so that server
        // has time to emit "user/poll/save" if necessary
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.session.socket.disconnect()
        }
    }
    
    // MARK: Update poll with given name and then save it to UserDefaults
    func updateSavePoll(pollId: Int, name: String) {
        UpdatePoll(id: pollId, name: name).make()
            .done { poll -> Void in
                self.encodeObjForKey(obj: poll, key: "currentPoll")
                self.saveAdminPoll(poll: poll)
            }.catch { error -> Void in
                print(error)
        }
    }
    
    // MARK: Save poll to adminSavedPolls in UserDefaults
    func saveAdminPoll(poll: Poll) {
        // Check if any adminSavedPolls exist
        guard let adminSavedPolls = UserDefaults.standard.value(forKey: "adminSavedPolls") else {
            encodeObjForKey(obj: [poll], key: "adminSavedPolls")
            return
        }
        
        var polls = decodeObjForKey(key: "adminSavedPolls") as! [Poll]
        // Check if poll has been saved already
        if (isOldPoll) {
            let pollCodes = polls.map { $0.code }
            polls[pollCodes.index(of: poll.code)!] = poll
        } else {
            polls.append(poll)
        }
        encodeObjForKey(obj: polls, key: "adminSavedPolls")
    }
    
    // MARK: End poll
    func endPoll(pollId: Int, save: Bool) {
        EndPoll(id: pollId, save: save).make()
            .done { Void -> Void in
                print("ended poll")
            }.catch { error -> Void in
                print(error)
        }
    }
    
    // MARK: - Setup/layout views
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
    
    // MARK: - Keyboard handling
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = view.frame.height
            }
        }
    }
    
}
