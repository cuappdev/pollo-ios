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
    func startPoll(text: String, type: QuestionType, options: [String], state: PollState)
}

protocol PollBuilderDelegate {
    func updateCanDraft(_ canDraft: Bool)
}

class PollBuilderViewController: UIViewController, QuestionDelegate, PollBuilderDelegate, FillsDraftDelegate, PollTypeDropDownDelegate{
    
    // MARK: layout constants
    let questionTypeButtonWidth: CGFloat = 150
    let draftsButtonWidth: CGFloat = 100
    let popupViewHeight: CGFloat = 95
    let edgePadding: CGFloat = 18
    let topBarHeight: CGFloat = 24
    let dropdownArrowHeight: CGFloat = 5.5
    let buttonsViewHeight: CGFloat = 67.5
    let buttonHeight: CGFloat = 47.5

    // MARK: subviews and VC's
    var pickQTypeVC: PickQTypeViewController!
    var dropDown: PollTypeDropDownView!
    var dropDownArrow: UIImageView!
    var dismissController: UIViewController!
    var exitButton: UIButton!
    var questionTypeButton: UIButton!
    var draftsButton: UIButton!
    var centerView: UIView!
    var buttonsView: UIView!
    var saveDraftButton: UIButton!
    var startQuestionButton: UIButton!
    var mcPollBuilder: MCPollBuilderView!
    var frPollBuilder: FRPollBuilderView!
    
    // MARK: data
    var drafts: [Draft]!
    var questionType: QuestionType!
    var startPollDelegate: StartPollDelegate!
    var isFollowUpQuestion: Bool = false
    var canDraft: Bool!
    var presented: Bool = false
    var loadedMCDraft: Draft?
    var loadedFRDraft: Draft?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clickerWhite
        questionType = .multipleChoice
        
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
    
    // MARK: Setup
    
    func setupViews() {
        navigationController?.navigationBar.isHidden = true
        
        exitButton = UIButton()
        exitButton.setImage(#imageLiteral(resourceName: "SmallExitIcon"), for: .normal)
        exitButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
        view.addSubview(exitButton)
        
        questionTypeButton = UIButton()
        questionTypeButton.setTitle("Multiple Choice", for: .normal)
        questionTypeButton.setTitleColor(.clickerBlack0, for: .normal)
        questionTypeButton.titleLabel?.font = ._16SemiboldFont
        questionTypeButton.contentHorizontalAlignment = .center
        questionTypeButton.addTarget(self, action: #selector(toggleQuestionType), for: .touchUpInside)
        questionTypeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: questionTypeButton.titleLabel!.frame.size.width)
        view.addSubview(questionTypeButton)
        
        draftsButton = UIButton()
        updateDraftsCount()
        draftsButton.setTitleColor(.clickerBlack0, for: .normal)
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
        divider.backgroundColor = .clickerGrey5
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
        startQuestionButton.backgroundColor = .clickerGreen0
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
        let questionTypeText = questionType.description
        let otherTypeText = questionType.other.description
        questionTypeButton.setTitle(questionTypeText, for: .normal)
        dropDown.topButton.setTitle(questionTypeText, for: .normal)
        dropDown.bottomButton.setTitle(otherTypeText, for: .normal)
    }
    
    // MARK - ACTIONS
    
    @objc func saveAsDraft() {
        if canDraft {
            guard let type = questionType else {
                print("warning! cannot save as draft before viewDidLoad")
                return
            }
            switch type {
            case .multipleChoice:
                let question = mcPollBuilder.questionTextField.text
                var options = mcPollBuilder.options.filter { $0 != "" }
                if options == [] {
                    options.append("")
                }
                if let loadedDraft = loadedMCDraft {
                    UpdateDraft(id: "\(loadedDraft.id)", text: question!, options: options).make()
                        .done { draft in
                            self.getDrafts()
                        }.catch { error in
                            print("error: ", error)
                    }
                } else {
                    CreateDraft(text: question!, options: options).make()
                        .done { draft in
                            self.drafts.append(draft)
                            self.updateDraftsCount()
                        }.catch { error in
                            print("error: ", error)
                    }
                }
                self.mcPollBuilder.clearOptions()
                self.mcPollBuilder.questionTextField.text = ""
                self.mcPollBuilder.optionsTableView.reloadData()
            
            case .freeResponse:
                let question = frPollBuilder.questionTextField.text
                if let loadedDraft = loadedFRDraft {
                    UpdateDraft(id: "\(loadedDraft.id )", text: question!, options: []).make()
                        .done { draft in
                            self.getDrafts()
                        }.catch { error in
                            print("error: ", error)
                    }
                } else {
                    CreateDraft(text: question!, options: []).make()
                        .done { draft in
                            self.drafts.append(draft)
                            self.updateDraftsCount()
                        }.catch { error in
                            print("error: ", error)
                    }
                }
                self.frPollBuilder.questionTextField.text = ""
            }
            self.updateCanDraft(false)
        }
    }
    
    @objc func startQuestion() {
        // MULTIPLE CHOICE
        guard let qType = questionType else {
            print("cannot start question before viewdidload")
            return
        }
        switch qType {
        case .multipleChoice:
            let question = mcPollBuilder.questionTextField.text
            startPollDelegate.startPoll(text: question!, type: .multipleChoice, options: mcPollBuilder.options, state: .live)
        case .freeResponse:
            let question = frPollBuilder.questionTextField.text
            startPollDelegate.startPoll(text: question!, type: .freeResponse, options: [], state: .live)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK - DROP DOWN
    
    func setupDropDown() {
        dropDownArrow = UIImageView(image: UIImage(named: "DropdownArrowIcon"))
        view.addSubview(dropDownArrow)
        
        dropDown = PollTypeDropDownView()
        let topTitle = questionType.description
        let bottomTitle = questionType.other.description
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
    
    @objc func toggleQuestionType() {
        dropDown.isHidden = false
        
    }
    
    // MARK - PickQTypeDelegate
    
    func updateQuestionType() {
        questionType = questionType.other
        updateQuestionTypeButton()
        guard let type = questionType else {
            print("question type must be initalized before updateQuestionTypeCalled.")
            return
        }
        switch type {
        case .multipleChoice :
            mcPollBuilder.isHidden = false
            frPollBuilder.isHidden = true
            
        case .freeResponse:
            frPollBuilder.isHidden = false
            mcPollBuilder.isHidden = true
        }
    }
    
    @objc func showDrafts() {
        
        let draftsVC = DraftsViewController()
        draftsVC.drafts = drafts
        draftsVC.delegate = self
        draftsVC.modalPresentationStyle = .overCurrentContext
        present(draftsVC, animated: true, completion: nil)
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
            saveDraftButton.setTitleColor(.clickerGreen0, for: .normal)
            saveDraftButton.backgroundColor = .clear
            saveDraftButton.layer.borderColor = UIColor.clickerGreen0.cgColor
        } else {
            saveDraftButton.setTitleColor(.clickerGrey2, for: .normal)
            saveDraftButton.backgroundColor = .clickerGrey6
            saveDraftButton.layer.borderColor = UIColor.clickerGrey6.cgColor
            draftsButton.titleLabel?.font = ._16MediumFont
        }
    }
    
    func fillDraft(_ draft: Draft) {
        let qType: QuestionType = (draft.options == []) ? .freeResponse : .multipleChoice
        if questionType != qType {
            updateQuestionType()
        }
        switch qType {
        case .multipleChoice:
            mcPollBuilder.fillDraft(title: draft.text, options: draft.options)
            mcPollBuilder.optionsTableView.reloadData()
            loadedMCDraft = draft
        case .freeResponse:
            frPollBuilder.questionTextField.text = draft.text
            loadedFRDraft = draft
        }
        updateCanDraft(true)
    }
    
    func getDrafts() {
        GetDrafts().make()
            .done { drafts in
                self.drafts = drafts
                self.updateDraftsCount()
            } .catch { error in
                print("error: ", error)
        }
    }
    
    func updateDraftsCount() {
        if let _ = drafts {
            draftsButton.setTitle("Drafts (\(drafts.count))", for: .normal)
        } else {
            draftsButton.setTitle("Drafts (0)", for: .normal)
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
