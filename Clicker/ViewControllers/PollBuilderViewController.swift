//
//  PollBuilderViewController.swift
//  Clicker
//
//  Created by Annie Cheng on 4/18/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import Presentr

protocol PollBuilderViewDelegate: class {
    func ignoreNextKeyboardHiding()
    func updateCanDraft(_ canDraft: Bool)
    func updateCorrectAnswer(correctAnswer: String?)
    var isKeyboardShown: Bool { get }
}

protocol PollBuilderViewControllerDelegate: class {
    func startPoll(text: String, type: QuestionType, options: [String], state: PollState, answerChoices: [PollResult], correctAnswer: String?, shouldPopViewController: Bool)
    func showNavigationBar()
}

class PollBuilderViewController: UIViewController {

    // MARK: View vars
    var bottomPaddingView: UIView!
    var buttonsView: UIView!
    var centerView: UIView!
    var dimmingView: UIView!
    var dropDown: QuestionTypeDropDownView!
    var dropDownArrow: UIButton!
    var dropDownGestureRecognizer: UITapGestureRecognizer!
    var exitButton: UIButton!
    var frPollBuilder: FRPollBuilderView!
    var mcPollBuilder: MCPollBuilderView!
    var questionTypeButton: UIButton!
    var quizModeOverlayView: QuizModeOverlayView!
    var saveDraftButton: UIButton!
    var startPollButton: UIButton!
    var tapGestureRecognizer: UITapGestureRecognizer!
    var topPaddingView: UIView!
    
    // MARK: Data vars
    private let networking: Networking = URLSession.shared.request
    var answerChoices: [PollResult]!
    var canDraft: Bool!
    var correctAnswer: String?
    var drafts: [Draft] = []
    var dropDownHidden: Bool = true
    var isFollowUpQuestion: Bool = false
    var isKeyboardShown: Bool = false
    var loadedFRDraft: Draft?
    var loadedMCDraft: Draft?
    var questionType: QuestionType!
    var shouldIgnoreNextKeyboardHiding: Bool = false
    weak var delegate: PollBuilderViewControllerDelegate?
    
    // MARK: Constants
    let buttonHeight: CGFloat = 47.5
    let buttonsViewHeight: CGFloat = 67.5
    let centerViewHeight: CGFloat = 24
    let centerViewWidth: CGFloat = 135
    let draftsButtonWidth: CGFloat = 100
    let dropDownArrowHeight: CGFloat = 13
    let dropDownArrowImageName = "DropdownArrowIcon"
    let dropDownArrowInset: CGFloat = 10
    let dropDownArrowLeftPadding: CGFloat = 5.0
    let dropDownArrowWidth: CGFloat = 13
    let dropDownHeight: CGFloat = 100
    let edgePadding: CGFloat = 18
    let editDraftModalSize: CGFloat = 50
    let errorText = "Error"
    let exitButtonImageName = "darkexit"
    let failedToDeleteDraftText = "Failed to delete draft. Try again!"
    let popupViewHeight: CGFloat = 95
    let saveDraftButtonTitle = "Save as draft"
    let startPollButtonTitle = "Start Poll"
    let topBarHeight: CGFloat = 24
    
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if quizModeOverlayView != nil {
            let mcPollBuilderCVFrame = mcPollBuilder.collectionView.frame
            let collectionViewFrame = mcPollBuilder.convert(mcPollBuilderCVFrame, to: view)
            let circleImageXOffset: CGFloat = 12.0
            let circleImageYOffset: CGFloat = circleImageXOffset
            let circleImageFrame = CGRect(x: collectionViewFrame.origin.x + circleImageXOffset, y: collectionViewFrame.origin.y + circleImageYOffset, width: collectionViewFrame.width, height: collectionViewFrame.height)
            quizModeOverlayView.configure(with: circleImageFrame)
        }
    }
    
    // MARK: - Layout
    func setupViews() {
        navigationController?.navigationBar.isHidden = true
        
        exitButton = UIButton()
        exitButton.setImage(UIImage(named: exitButtonImageName), for: .normal)
        exitButton.imageEdgeInsets = LayoutConstants.buttonImageInsets
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
        
        dropDownArrow = UIButton()
        let dropDownArrowImage = UIImage(named: dropDownArrowImageName)
        dropDownArrow.setImage(dropDownArrowImage, for: .normal)
        dropDownArrow.contentMode = .scaleAspectFit
        dropDownArrow.addTarget(self, action: #selector(toggleQuestionType), for: .touchUpInside)
        centerView.addSubview(dropDownArrow)
        
        mcPollBuilder = MCPollBuilderView()
        mcPollBuilder.configure(with: self, pollBuilderDelegate: self)
        
        view.addSubview(mcPollBuilder)
        
        frPollBuilder = FRPollBuilderView()
        frPollBuilder.configure(with: self, pollBuilderDelegate: self)
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
        
        startPollButton = UIButton()
        startPollButton.setTitle(startPollButtonTitle, for: .normal)
        startPollButton.setTitleColor(.white, for: .normal)
        startPollButton.titleLabel?.font = ._16SemiboldFont
        startPollButton.backgroundColor = .clickerGreen0
        startPollButton.layer.cornerRadius = buttonHeight / 2
        startPollButton.addTarget(self, action: #selector(startPoll), for: .touchUpInside)
        buttonsView.addSubview(startPollButton)
        
        bottomPaddingView = UIView()
        bottomPaddingView.backgroundColor = .white
        view.addSubview(bottomPaddingView)

        let displayedQuizModeOverlay = UserDefault.getBoolValue(for: UserDefault.Keys.displayQuizOverlay)
        if !displayedQuizModeOverlay {
            quizModeOverlayView = QuizModeOverlayView()
            view.addSubview(quizModeOverlayView)
            UserDefault.set(value: true, for: UserDefault.Keys.displayQuizOverlay)
        }
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
            make.left.equalTo(edgePadding - LayoutConstants.buttonImageInsets.left)
            make.top.equalTo(edgePadding - LayoutConstants.buttonImageInsets.top)
            make.size.equalTo(LayoutConstants.buttonSize)
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
        
        startPollButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(edgePadding)
            make.centerY.equalToSuperview()
            make.width.equalTo(saveDraftButton.snp.width)
            make.height.equalTo(buttonHeight)
        }
        
        mcPollBuilder.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(edgePadding)
            make.right.equalToSuperview().inset(edgePadding)
            make.top.equalTo(questionTypeButton.snp.bottom).offset(28)
            make.bottom.equalTo(buttonsView.snp.top)
        }
        
        frPollBuilder.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(edgePadding)
            make.right.equalToSuperview().inset(edgePadding)
            make.top.equalTo(mcPollBuilder.snp.top)
            make.bottom.equalTo(mcPollBuilder.snp.bottom)
        }
        
        bottomPaddingView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(buttonsView.snp.bottom)
        }

        if quizModeOverlayView != nil {
            quizModeOverlayView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    func updateQuestionTypeButton() {
        let questionTypeText: String = questionType == .multipleChoice ? "Multiple Choice" : "Free Response"
        questionTypeButton.setTitle(questionTypeText, for: .normal)
    }
    
    func updateDraft(id: String, text: String, options: [String]) -> Future<Response<Draft>> {
        return networking(Endpoint.updateDraft(id: id, text: text, options: options)).decode()
    }
    
    func createDraft(text: String, options: [String]) -> Future<Response<Draft>> {
        return networking(Endpoint.createDraft(text: text, options: options)).decode()
    }
    
    // MARK: - Actions
    @objc func saveAsDraft() {
        if !canDraft { return }
        guard let type = questionType else {
            print("warning! cannot save as draft before viewDidLoad")
            return
        }
        switch type {
        case .multipleChoice:
            let question = mcPollBuilder.questionText ?? ""
            var options = mcPollBuilder.getOptions()
           if options.isEmpty {
                options.append("")
                options.append("")
           }
            if let loadedDraft = loadedMCDraft {
                updateDraft(id: "\(loadedDraft.id)", text: question, options: options).observe { [weak self] result in
                    guard let `self` = self else { return }
                    DispatchQueue.main.async {
                        switch result {
                        case .value:
                            self.getDrafts()
                        case .error(let error):
                            print("error: ", error)
                        }
                    }
                }
            } else {
                createDraft(text: question, options: options).observe { [weak self] result in
                    guard let `self` = self else { return }
                    DispatchQueue.main.async {
                        switch result {
                        case .value:
                            self.getDrafts()
                        case .error(let error):
                            print("error: ", error)
                        }
                    }
                }
            }
            loadedMCDraft = nil
            self.mcPollBuilder.reset()
            
        case .freeResponse:
            let question = frPollBuilder.questionText ?? ""
            if let loadedDraft = loadedFRDraft {
                updateDraft(id: "\(loadedDraft.id)", text: question, options: []).observe { [weak self] result in
                    guard let `self` = self else { return }
                    DispatchQueue.main.async {
                        switch result {
                        case .value:
                            self.getDrafts()
                        case .error(let error):
                            print("error: ", error)
                        }
                    }
                }
            } else {
                createDraft(text: question, options: []).observe { [weak self] result in
                    guard let `self` = self else { return }
                    DispatchQueue.main.async {
                        switch result {
                        case .value:
                            self.getDrafts()
                        case .error(let error):
                            print("error: ", error)
                        }
                    }
                }
            }
            loadedFRDraft = nil
            self.frPollBuilder.reset()
        }
        self.updateCanDraft(false)
        Analytics.shared.log(with: CreatedDraftPayload())
    }
    
    @objc func startPoll() {
        // MULTIPLE CHOICE
        guard let questionType = questionType else {
            print("cannot start question before viewdidload")
            return
        }
        
        delegate?.showNavigationBar()
        dismiss(animated: true, completion: nil)
        hideKeyboard()
        
        switch questionType { 
        case .multipleChoice:
            answerChoices = mcPollBuilder.getChoices()
            let question = mcPollBuilder.questionText ?? ""
            delegate?.startPoll(text: question, type: .multipleChoice, options: mcPollBuilder.getOptions(), state: .live, answerChoices: answerChoices, correctAnswer: correctAnswer, shouldPopViewController: true)
        case .freeResponse:
            let question = frPollBuilder.questionText ?? ""
            delegate?.startPoll(text: question, type: .freeResponse, options: [], state: .live, answerChoices: [], correctAnswer: nil, shouldPopViewController: true)
        }

        if loadedMCDraft != nil || loadedFRDraft != nil {
            Analytics.shared.log(with: CreatedPollFromDraftPayload())
        } else {
            Analytics.shared.log(with: CreatedPollPaylod())
        }
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
    
    @objc func exit() {
        delegate?.showNavigationBar()
        dismiss(animated: true, completion: nil)
    }
    
    func deleteDraft(with id: String) -> Future<DeleteResponse> {
        return networking(Endpoint.deleteDraft(with: id)).decode()
    }
    
    func allDrafts() -> Future<Response<[Draft]>> {
        return networking(Endpoint.getDrafts()).decode()
    }
    
    // MARK: - Helpers
    func getDrafts() {
        allDrafts().observe { [weak self] result in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .value(let response):
                    self.drafts = response.data
                    self.updatePollBuilderViews()
                case .error(let error):
                    print("error: ", error)
                }
            }
        }
    }

    func updatePollBuilderViews() {
        self.mcPollBuilder.needsPerformUpdates()
        self.frPollBuilder.needsPerformUpdates()
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
        if shouldIgnoreNextKeyboardHiding {
            shouldIgnoreNextKeyboardHiding = false
            return
        }
        if (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue != nil {
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
