//
//  PollBuilderViewController.swift
//  Clicker
//
//  Created by Annie Cheng on 4/18/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import Presentr
import DropDown

protocol StartPollDelegate {
    func startPoll(text: String, type: String, options: [String])
}

protocol PollBuilderDelegate {
    func updateDrafts(_ canDraft: Bool)
}

class PollBuilderViewController: UIViewController, QuestionDelegate, PollBuilderDelegate {
    
    let questionTypeButtonWidth: CGFloat = 150
    let draftsButtonWidth: CGFloat = 100
    let popupViewHeight: CGFloat = 95
    var pickQTypeVC: PickQTypeViewController!
    var dropDown: DropDown!
    
    let edgePadding: CGFloat = 18
    let topBarHeight: CGFloat = 24
    let dropdownArrowHeight: CGFloat = 5.5
    let buttonsViewHeight: CGFloat = 67.5
    let buttonHeight: CGFloat = 47.5
    
    var dismissController: UIViewController!
    
    var exitButton: UIButton!
    var questionTypeButton: UIButton!
    var draftsButton: UIButton!
    var numDrafts: Int = 0 // TODO: use actual # of drafts
    var questionType: String!
    
    var startPollDelegate: StartPollDelegate!
    var isFollowUpQuestion: Bool = false
    
    var centerView: UIView!
    var mcPollBuilder: MCPollBuilderView!
    var frPollBuilder: FRPollBuilderView!
    
    var canDraft: Bool!
    var buttonsView: UIView!
    var saveDraftButton: UIButton!
    var startQuestionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clickerWhite
        questionType = "MULTIPLE_CHOICE"
        
        // Add Keyboard Handlers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupDropDown()
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        exitButton = UIButton()
        exitButton.setImage(#imageLiteral(resourceName: "SmallExitIcon"), for: .normal)
        exitButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
        view.addSubview(exitButton)
        
        questionTypeButton = UIButton()
        updateQuestionTypeButton()
        questionTypeButton.setTitleColor(.clickerBlack, for: .normal)
        questionTypeButton.titleLabel?.font = ._16SemiboldFont
        questionTypeButton.contentHorizontalAlignment = .center
        questionTypeButton.addTarget(self, action: #selector(toggleQuestionType), for: .touchUpInside)
        questionTypeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: questionTypeButton.titleLabel!.frame.size.width)
        view.addSubview(questionTypeButton)
        
        draftsButton = UIButton()
        draftsButton.setTitle("Drafts (\(numDrafts))", for: .normal)
        draftsButton.setTitleColor(.clickerBlack, for: .normal)
        draftsButton.titleLabel?.font = ._16MediumFont
        draftsButton.contentHorizontalAlignment = .right
        draftsButton.addTarget(self, action: #selector(showDrafts), for: .touchUpInside)
        view.addSubview(draftsButton)
        
        centerView = UIView()
        view.addSubview(centerView)
        
        mcPollBuilder = MCPollBuilderView()
        mcPollBuilder.pollBuilderDelegate = self
        view.addSubview(mcPollBuilder)
        
        frPollBuilder = FRPollBuilderView()
        frPollBuilder.pollBuilderDelegate = self
        view.addSubview(frPollBuilder)
        frPollBuilder.isHidden = true
        
        buttonsView = UIView()
        buttonsView.backgroundColor = .white
        view.addSubview(buttonsView)
        
        let divider = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1.5))
        divider.backgroundColor = .clickerBorder
        buttonsView.addSubview(divider)
        
        saveDraftButton = UIButton()
        saveDraftButton.setTitle("Save as draft", for: .normal)
        canDraft = false
        updateDrafts(canDraft)
        saveDraftButton.titleLabel?.font = ._16SemiboldFont
        saveDraftButton.layer.cornerRadius = buttonHeight / 2
        saveDraftButton.layer.borderWidth = 1.5
        saveDraftButton.addTarget(self, action: #selector(saveAsDraft), for: .touchUpInside)
        buttonsView.addSubview(saveDraftButton)
        
        startQuestionButton = UIButton()
        startQuestionButton.setTitle("Start Question", for: .normal)
        startQuestionButton.setTitleColor(.white, for: .normal)
        startQuestionButton.titleLabel?.font = ._16SemiboldFont
        startQuestionButton.backgroundColor = .clickerGreen
        startQuestionButton.layer.cornerRadius = buttonHeight / 2
        startQuestionButton.addTarget(self, action: #selector(startQuestion), for: .touchUpInside)
        buttonsView.addSubview(startQuestionButton)
    }
    
    func setupConstraints() {
        exitButton.snp.makeConstraints { make in
            make.left.equalTo(edgePadding)
            make.top.equalTo(edgePadding)
            make.width.equalTo(topBarHeight)
            make.height.equalTo(topBarHeight)
        }
        
        questionTypeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(edgePadding)
            make.width.equalTo(questionTypeButtonWidth)
            make.height.equalTo(topBarHeight)
        }
        
        draftsButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(edgePadding)
            make.top.equalTo(edgePadding)
            make.width.equalTo(draftsButtonWidth)
            make.height.equalTo(topBarHeight)
        }
        
        buttonsView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(buttonsViewHeight)
        }
        
        saveDraftButton.snp.makeConstraints { make in
            make.left.equalTo(edgePadding)
            make.centerY.equalToSuperview()
            make.width.equalTo(161)
            make.height.equalTo(buttonHeight)
        }
        
        startQuestionButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(edgePadding)
            make.centerY.equalToSuperview()
            make.width.equalTo(saveDraftButton.snp.width)
            make.height.equalTo(buttonHeight)
        }
        
        mcPollBuilder.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(36)
            make.centerX.equalToSuperview()
            make.top.equalTo(questionTypeButton.snp.bottom).offset(28)
            make.bottom.equalTo(buttonsView.snp.top)
        }
        
        frPollBuilder.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(36)
            make.centerX.equalToSuperview()
            make.top.equalTo(mcPollBuilder.snp.top)
            make.bottom.equalTo(mcPollBuilder.snp.bottom)
        }
        
    }
    
    
    func updateQuestionTypeButton() {
        let questionTypeText = (questionType == "MULTIPLE_CHOICE") ? "Multiple Choice" : "Free Response"
        dropDown.dataSource = [(questionType == "MULTIPLE_CHOICE") ? "Multiple Choice" : "Free Response",
                               (questionType == "FREE_RESPONSE") ? "Multiple Choice" : "Free Response"]
        questionTypeButton.setTitle(questionTypeText, for: .normal)
    }
    
    // MARK - ACTIONS
    
    @objc func saveAsDraft() {
        if canDraft {
            print("save as draft")
            // MULTIPLE CHOICE
            if (questionType == "MULTIPLE_CHOICE") {
                let question = mcPollBuilder.questionTextField.text
                let options = mcPollBuilder.optionsDict.keys.sorted().map { mcPollBuilder.optionsDict[$0]! }
                
                CreateDraft(text: question!, options: options).make()
                    .done { _ in
                        
                        }.catch { error in
                            print("error: ", error)
                    }
            
            } else { // FREE RESPONSE
                //let question = frPollBuilder.questionTextField.text

            }
            self.dismiss(animated: true, completion: nil)
            }  else {
            print("empty, drafts disabled")
        }
        GetDrafts().make()
            .done { drafts in
                let draft = drafts[0]
                print(draft)
            } .catch { error in
                print("error: ",error)
            }
        
    }
    
    @objc func startQuestion() {
        // TODO: Start question session
        print("start question")
        
        // MULTIPLE CHOICE
        if (questionType == "MULTIPLE_CHOICE") {

            let question = mcPollBuilder.questionTextField.text
            let options = mcPollBuilder.optionsDict.keys.sorted().map { mcPollBuilder.optionsDict[$0]! }
            
            startPollDelegate.startPoll(text: question!, type: "MULTIPLE_CHOICE", options: options)
        } else { // FREE RESPONSE
            
            let question = frPollBuilder.questionTextField.text
            
            startPollDelegate.startPoll(text: question!, type: "FREE_RESPONSE", options: [])
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupDropDown() {
        dropDown = DropDown()
        dropDown.anchorView = exitButton
        dropDown.width = view.frame.width
        dropDown.dataSource = ["Multiple Choice", "Free Response"]
        dropDown.direction = .bottom
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected dropdown item: \(item) at index: \(index)")
            if index == 1 {
                self.updateQuestionType()
            }
        }
    }
    
    // TODO: Show a dropdown of question types
    @objc func toggleQuestionType() {
        dropDown.show()
    }
    
    // MARK - PickQTypeDelegate
    
    func updateQuestionType() {
        questionType = (questionType == "MULTIPLE_CHOICE") ? "FREE_RESPONSE" : "MULTIPLE_CHOICE"
        updateQuestionTypeButton()
        if questionType == "MULTIPLE_CHOICE" {
            mcPollBuilder.isHidden = false
            frPollBuilder.isHidden = true
            print("showing mc")
            
        } else { //  FREE_RESPONSE
            frPollBuilder.isHidden = false
            mcPollBuilder.isHidden = true
            print("showing fr")
        }
    }
    
    @objc func showDrafts() {
        print("show poll drafts")
        
        let draftsVC = DraftsViewController()
        //(startPollDelegate as! UIViewController).navigationController?.pushViewController(draftsVC, animated: true)
        navigationController?.pushViewController(draftsVC, animated: true)
        self.dismiss(animated: false, completion: nil)
        
    }
    
    @objc func exit() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - QUESTION DELEGATE
    
    func inFollowUpQuestion() {
        isFollowUpQuestion = true
    }
    
    // MARK: POLLBUILDER DELEGATE
    func updateDrafts(_ canDraft: Bool) {
        self.canDraft = canDraft
        if canDraft {
            saveDraftButton.setTitleColor(.clickerGreen, for: .normal)
            saveDraftButton.backgroundColor = .clear
            saveDraftButton.layer.borderColor = UIColor.clickerGreen.cgColor
            print("drafts enabled")
        } else {
            saveDraftButton.setTitleColor(.clickerMediumGray, for: .normal)
            saveDraftButton.backgroundColor = .clickerOptionGrey
            saveDraftButton.layer.borderColor = UIColor.clickerOptionGrey.cgColor
            draftsButton.titleLabel?.font = ._16MediumFont
            print("draft disabled")
        }
        
    }
    
    // MARK: - KEYBOARD
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            buttonsView.frame.origin.y = view.frame.height - keyboardSize.height - buttonsViewHeight
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            buttonsView.frame.origin.y += keyboardSize.height
        }
    }

}
