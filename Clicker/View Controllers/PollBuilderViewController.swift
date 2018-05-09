//
//  PollBuilderViewController.swift
//  Clicker
//
//  Created by Annie Cheng on 4/18/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import Presentr

protocol StartPollDelegate {
    func startPoll(text: String, type: String, options: [String], isShared: Bool)
}

protocol PollBuilderDelegate {
    func updateCanDraft(_ canDraft: Bool)
}

class PollBuilderViewController: UIViewController, QuestionDelegate, PollBuilderDelegate, FillsDraftDelegate, PollTypeDropDownDelegate{
    
    let questionTypeButtonWidth: CGFloat = 150
    let draftsButtonWidth: CGFloat = 100
    let popupViewHeight: CGFloat = 95
    var pickQTypeVC: PickQTypeViewController!
    
    var dropDown: PollTypeDropDownView!
    var dropDownArrow: UIImageView!
    
    let edgePadding: CGFloat = 18
    let topBarHeight: CGFloat = 24
    let dropdownArrowHeight: CGFloat = 5.5
    let buttonsViewHeight: CGFloat = 67.5
    let buttonHeight: CGFloat = 47.5
    
    var dismissController: UIViewController!
    
    var exitButton: UIButton!
    var questionTypeButton: UIButton!
    var draftsButton: UIButton!
    var drafts: [Draft]!
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
    
    var presented: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clickerWhite
        questionType = "MULTIPLE_CHOICE"
        
        // Add Keyboard Handlers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !presented {
            setupViews()
            setupConstraints()
            setupDropDown()
        }
        presented = true
        getDrafts()
    }
    
    func setupViews() {
        navigationController?.navigationBar.isHidden = true
        
        exitButton = UIButton()
        exitButton.setImage(#imageLiteral(resourceName: "SmallExitIcon"), for: .normal)
        exitButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
        view.addSubview(exitButton)
        
        questionTypeButton = UIButton()
        questionTypeButton.setTitle("Multiple Choice", for: .normal)
        questionTypeButton.setTitleColor(.clickerBlack, for: .normal)
        questionTypeButton.titleLabel?.font = ._16SemiboldFont
        questionTypeButton.contentHorizontalAlignment = .center
        questionTypeButton.addTarget(self, action: #selector(toggleQuestionType), for: .touchUpInside)
        questionTypeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: questionTypeButton.titleLabel!.frame.size.width)
        view.addSubview(questionTypeButton)
        
        draftsButton = UIButton()
        draftsButton.setTitle("Drafts (\((drafts ?? []).count))", for: .normal)
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
        updateCanDraft(canDraft)
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
        let otherTypeText = (questionType == "MULTIPLE_CHOICE") ? "Free Response" : "Multiple Choice"
        questionTypeButton.setTitle(questionTypeText, for: .normal)
        dropDown.topButton.setTitle(questionTypeText, for: .normal)
        dropDown.bottomButton.setTitle(otherTypeText, for: .normal)
    }
    
    // MARK - ACTIONS
    
    
    @objc func saveAsDraft() {
        if canDraft {
            print("save as draft")
            // MULTIPLE CHOICE
            if (questionType == "MULTIPLE_CHOICE") {
                let question = mcPollBuilder.questionTextField.text
                let options = mcPollBuilder.optionsDict.keys.sorted().map { mcPollBuilder.optionsDict[$0]! }
                
                print("creating a draft with:\n\t text: ",question,"\n\toptions: ", options)
                CreateDraft(text: question!, options: options).make()
                    .done { draft in
                        print("made draft with options: ", draft.options)
                    }.catch { error in
                            print("error: ", error)
                    }
                self.mcPollBuilder.clearOptionsDict()
                self.mcPollBuilder.questionTextField.text = ""
                self.mcPollBuilder.optionsTableView.reloadData()
            
            } else { // FREE RESPONSE
                //let question = frPollBuilder.questionTextField.text

            }
            self.updateCanDraft(false)
            self.getDrafts()
            }  else {
            print("empty, drafts disabled")
        }
        
    }
    
    @objc func startQuestion() {
        // TODO: Start question session
        print("start question")
        
        // MULTIPLE CHOICE
        if (questionType == "MULTIPLE_CHOICE") {

            let question = mcPollBuilder.questionTextField.text
            let options = mcPollBuilder.optionsDict.keys.sorted().map { mcPollBuilder.optionsDict[$0]! }
            
            startPollDelegate.startPoll(text: question!, type: "MULTIPLE_CHOICE", options: options, isShared: false)
        } else { // FREE RESPONSE
            
            let question = frPollBuilder.questionTextField.text
            let isShared = frPollBuilder.dropDown.shareResponses
            startPollDelegate.startPoll(text: question!, type: "FREE_RESPONSE", options: [], isShared: isShared)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK - DROP DOWN
    
    func setupDropDown() {
        dropDownArrow = UIImageView(image: UIImage(named: "DropdownArrowIcon"))
        view.addSubview(dropDownArrow)
        
        dropDown = PollTypeDropDownView()
        let topTitle = (questionType == "MULTIPLE_CHOICE") ? "Multiple Choice" : "Free Response"
        let bottomTitle = (questionType == "MULTIPLE_CHOICE") ? "Free Response" : "Multiple Choice"
        dropDown.topButton.setTitle(topTitle, for: .normal)
        dropDown.bottomButton.setTitle(bottomTitle, for: .normal)
        dropDown.delegate = self
        view.addSubview(dropDown)
        
        dropDown.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(questionTypeButton.snp.height).multipliedBy(2)
            make.centerY.equalTo(questionTypeButton.snp.bottom)
            make.centerX.equalToSuperview()
        }
        dropDownArrow.snp.makeConstraints { make in
            make.height.equalTo(6.5)
            make.width.equalTo(6.5)
            make.centerY.equalTo(questionTypeButton.snp.centerY)
            make.left.equalTo(questionTypeButton.snp.right)
        }
        dropDown.isHidden = true
        
    }
    
    // TODO: Show a dropdown of question types
    @objc func toggleQuestionType() {
        dropDown.isHidden = false
        
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
        draftsVC.drafts = drafts
        draftsVC.delegate = self
        navigationController?.pushViewController(draftsVC, animated: true)
    }
    
    @objc func exit() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - QUESTION DELEGATE
    
    func inFollowUpQuestion() {
        isFollowUpQuestion = true
    }
    
    // MARK: POLLBUILDER DELEGATE
    func updateCanDraft(_ canDraft: Bool) {
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
    
    func fillDraft(_ draft: Draft) {
        print("load draft: ", draft)
        if questionType == "MULTIPLE_CHOICE" {
            mcPollBuilder.questionTextField.text = draft.text
            var optionsDict: [Int: String] = [:]
            if draft.options.count > 0 {
                for i in 0...draft.options.count-1 {
                    optionsDict[i] = draft.options[i]
                }
            }
            mcPollBuilder.optionsDict = optionsDict
            mcPollBuilder.optionsTableView.reloadData()
        } else { // FREE_RESPONSE
            frPollBuilder.questionTextField.text = draft.text
        }
            updateCanDraft(true)
    }
    
    func getDrafts() {
        GetDrafts().make()
            .done { drafts in
                self.drafts = drafts
                print("got drafts!: ", drafts)
                self.draftsButton.setTitle("Drafts (\(drafts.count))", for: .normal)
            } .catch { error in
                print("error: ", error)
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
