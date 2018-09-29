//
//  PollBuilderViewController.swift
//  Clicker
//
//  Created by Annie Cheng on 4/18/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import Presentr

protocol PollBuilderViewDelegate {
    func updateCanDraft(_ canDraft: Bool)
}

protocol PollBuilderViewControllerDelegate {
    func startPoll(text: String, type: QuestionType, options: [String], state: PollState)
    func showNavigationBar()
}

class PollBuilderViewController: UIViewController {

    // MARK: View vars
    var dropDown: QuestionTypeDropDownView!
    var dropDownArrow: UIImageView!
    var exitButton: UIButton!
    var questionTypeButton: UIButton!
    var draftsButton: UIButton!
    var centerView: UIView!
    var buttonsView: UIView!
    var saveDraftButton: UIButton!
    var startQuestionButton: UIButton!
    var topPaddingView: UIView!
    var bottomPaddingView: UIView!
    var mcPollBuilder: MCPollBuilderView!
    var frPollBuilder: FRPollBuilderView!
    var tapGestureRecognizer: UITapGestureRecognizer!
    var dropDownGestureRecognizer: UITapGestureRecognizer!
    var dimmingView: UIView!
    
    // MARK: Data vars
    var drafts: [Draft]!
    var questionType: QuestionType!
    var delegate: PollBuilderViewControllerDelegate!
    var isFollowUpQuestion: Bool = false
    var canDraft: Bool!
    var loadedMCDraft: Draft?
    var loadedFRDraft: Draft?
    var isKeyboardShown: Bool = false
    var dropDownHidden: Bool = true
    
    // MARK: Constants
    let centerViewWidth: CGFloat = 135
    let centerViewHeight: CGFloat = 24
    let dropDownArrowLeftPadding: CGFloat = 7.5
    let draftsButtonWidth: CGFloat = 100
    let popupViewHeight: CGFloat = 95
    let edgePadding: CGFloat = 18
    let topBarHeight: CGFloat = 24
    let dropDownHeight: CGFloat = 100
    let dropDownArrowWidth: CGFloat = 13
    let dropDownArrowHeight: CGFloat = 13
    let dropDownArrowInset: CGFloat = 10
    let buttonsViewHeight: CGFloat = 67.5
    let buttonHeight: CGFloat = 47.5
    let saveDraftButtonTitle = "Save as draft"
    let startQuestionButtonTitle = "Start Question"
    
    init(delegate: PollBuilderViewControllerDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clickerWhite
        questionType = .multipleChoice
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Add Keyboard Handlers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        
        setupViews()
        setupConstraints()
        getDrafts()
    }
    
    // MARK: - Layout
    func setupViews() {
        navigationController?.navigationBar.isHidden = true
        
        exitButton = UIButton()
        exitButton.setImage(#imageLiteral(resourceName: "SmallExitIcon"), for: .normal)
        exitButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
        view.addSubview(exitButton)
        
        centerView = UIView()
        view.addSubview(centerView)
        
        questionTypeButton = UIButton()
        questionTypeButton.setTitle(StringConstants.multipleChoice, for: .normal)
        questionTypeButton.setTitleColor(.clickerBlack0, for: .normal)
        questionTypeButton.titleLabel?.font = ._16SemiboldFont
        questionTypeButton.contentHorizontalAlignment = .center
        questionTypeButton.addTarget(self, action: #selector(toggleQuestionType), for: .touchUpInside)
        questionTypeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: questionTypeButton.titleLabel!.frame.size.width)
        centerView.addSubview(questionTypeButton)
        
        dropDownArrow = UIImageView(image: UIImage(named: "DropdownArrowIcon"))
        dropDownArrow.contentMode = .scaleAspectFit
        centerView.addSubview(dropDownArrow)
        
        draftsButton = UIButton()
        updateDraftsCount()
        draftsButton.setTitleColor(.clickerBlack0, for: .normal)
        draftsButton.titleLabel?.font = ._16MediumFont
        draftsButton.contentHorizontalAlignment = .right
        draftsButton.addTarget(self, action: #selector(showDrafts), for: .touchUpInside)
        view.addSubview(draftsButton)
        
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
        saveDraftButton.setTitle(saveDraftButtonTitle, for: .normal)
        canDraft = false
        updateCanDraft(canDraft)
        saveDraftButton.titleLabel?.font = ._16SemiboldFont
        saveDraftButton.layer.cornerRadius = buttonHeight / 2
        saveDraftButton.layer.borderWidth = 1.5
        saveDraftButton.addTarget(self, action: #selector(saveAsDraft), for: .touchUpInside)
        buttonsView.addSubview(saveDraftButton)
        
        startQuestionButton = UIButton()
        startQuestionButton.setTitle(startQuestionButtonTitle, for: .normal)
        startQuestionButton.setTitleColor(.white, for: .normal)
        startQuestionButton.titleLabel?.font = ._16SemiboldFont
        startQuestionButton.backgroundColor = .clickerGreen0
        startQuestionButton.layer.cornerRadius = buttonHeight / 2
        startQuestionButton.addTarget(self, action: #selector(startQuestion), for: .touchUpInside)
        buttonsView.addSubview(startQuestionButton)
        
        bottomPaddingView = UIView()
        bottomPaddingView.backgroundColor = .white
        view.addSubview(bottomPaddingView)
    }
    
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 1.0
        view.addSubview(dimmingView)
        
        dimmingView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    func showDropDown() {
        setupDimmingView()
        
        dropDown = QuestionTypeDropDownView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: dropDownHeight), delegate: self, selectedQuestionType: questionType)
        view.addSubview(dropDown)
        
        topPaddingView = UIView()
        topPaddingView.backgroundColor = .white
        view.addSubview(topPaddingView)
        
        dropDown.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(dropDownHeight)
        }
        
        topPaddingView.snp.makeConstraints { make in
            make.centerX.width.top.equalToSuperview()
            make.bottom.equalTo(dropDown.snp.top)
        }
        dropDownHidden = false
    }
    
    @objc func hideDropDown() {
        dropDown.removeFromSuperview()
        topPaddingView.removeFromSuperview()
        dropDownHidden = true
        dimmingView.removeFromSuperview()
    }
    
    func setupConstraints() {
        exitButton.snp.makeConstraints { make in
            make.left.equalTo(edgePadding)
            make.top.equalTo(edgePadding + UIApplication.shared.statusBarFrame.height)
            make.width.equalTo(topBarHeight)
            make.height.equalTo(topBarHeight)
        }

        centerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(exitButton.snp.centerY)
            make.width.equalTo(centerViewWidth)
            make.height.equalTo(centerViewHeight)
        }
        
        questionTypeButton.snp.makeConstraints { make in
            make.centerY.leading.height.equalToSuperview()
        }
        
        dropDownArrow.snp.makeConstraints { make in
            make.width.equalTo(dropDownArrowWidth)
            make.height.equalTo(dropDownArrowHeight)
            make.centerY.equalTo(questionTypeButton.snp.centerY)
            make.leading.equalTo(questionTypeButton.snp.trailing).offset(dropDownArrowLeftPadding)
        }
        
        draftsButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(edgePadding)
            make.top.equalTo(exitButton.snp.top)
            make.width.equalTo(draftsButtonWidth)
            make.height.equalTo(topBarHeight)
        }
        
        buttonsView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
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
        
        bottomPaddingView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(buttonsView.snp.bottom)
        }
    }
    
    func updateQuestionTypeButton() {
        let questionTypeText: String = questionType == .multipleChoice ? "Multiple Choice" : "Free Response"
        questionTypeButton.setTitle(questionTypeText, for: .normal)
    }
    
    // MARK: - Actions
    @objc func saveAsDraft() {
        if canDraft {
            guard let type = questionType else {
                print("warning! cannot save as draft before viewDidLoad")
                return
            }
            switch type {
            case .multipleChoice:
                let question = mcPollBuilder.questionTextField.text ?? ""
                var options = mcPollBuilder.getOptions()
                if options.isEmpty {
                    options.append("")
                    options.append("")
                }
                if let loadedDraft = loadedMCDraft {
                    UpdateDraft(id: "\(loadedDraft.id)", text: question, options: options).make()
                        .done { draft in
                            self.getDrafts()
                        }.catch { error in
                            print("error: ", error)
                        }
                } else {
                    CreateDraft(text: question, options: options).make()
                        .done { draft in
                            self.drafts.append(draft)
                            self.updateDraftsCount()
                        }.catch { error in
                            print("error: ", error)
                    }
                }
                loadedMCDraft = nil
                self.mcPollBuilder.reset()
            
            case .freeResponse:
                let question = frPollBuilder.questionTextField.text ?? ""
                if let loadedDraft = loadedFRDraft {
                    UpdateDraft(id: "\(loadedDraft.id )", text: question, options: []).make()
                        .done { draft in
                            self.getDrafts()
                        }.catch { error in
                            print("error: ", error)
                    }
                } else {
                    CreateDraft(text: question, options: []).make()
                        .done { draft in
                            self.drafts.append(draft)
                            self.updateDraftsCount()
                        }.catch { error in
                            print("error: ", error)
                    }
                }
                loadedFRDraft = nil
                self.frPollBuilder.questionTextField.text = ""
            }
            self.updateCanDraft(false)
        }
    }
    
    @objc func startQuestion() {
        // MULTIPLE CHOICE
        guard let questionType = questionType else {
            print("cannot start question before viewdidload")
            return
        }
        switch questionType {
        case .multipleChoice:
            let question = mcPollBuilder.questionTextField.text ?? ""
            delegate.startPoll(text: question, type: .multipleChoice, options: mcPollBuilder.getOptions(), state: .live)
        case .freeResponse:
            let question = frPollBuilder.questionTextField.text ?? ""
            delegate.startPoll(text: question, type: .freeResponse, options: [], state: .live)
        }
        delegate.showNavigationBar()
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !dropDownHidden {
            hideDropDown()
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func toggleQuestionType() {
        if dropDownHidden {
            showDropDown()
        }
    }
    
    @objc func showDrafts() {
        let draftsVC = DraftsViewController(delegate: self, drafts: drafts)
        draftsVC.modalPresentationStyle = .overCurrentContext
        present(draftsVC, animated: true, completion: nil)
    }
    
    @objc func exit() {
        delegate.showNavigationBar()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
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
            let iphoneXBottomPadding = view.safeAreaInsets.bottom
            buttonsView.snp.updateConstraints { update in
                update.left.equalToSuperview()
                update.width.equalToSuperview()
                update.height.equalTo(buttonsViewHeight)
                update.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(keyboardSize.height - iphoneXBottomPadding)
            }
            buttonsView.superview?.layoutIfNeeded()
            isKeyboardShown = true
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            buttonsView.snp.updateConstraints { update in
                update.left.equalToSuperview()
                update.width.equalToSuperview()
                update.height.equalTo(buttonsViewHeight)
                update.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
            buttonsView.superview?.layoutIfNeeded()
            isKeyboardShown = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
