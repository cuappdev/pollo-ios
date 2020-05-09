//
//  PollBuilderViewController.swift
//  Pollo
//
//  Created by Annie Cheng on 4/18/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import FutureNova
import UIKit
import Presentr

protocol PollBuilderViewDelegate: class {
    func ignoreNextKeyboardHiding()
    func updateCanDraft(_ canDraft: Bool)
    func updateCorrectAnswer(correctAnswer: Int?)
    var isKeyboardShown: Bool { get }
}

protocol PollBuilderViewControllerDelegate: class {
    func startPoll(text: String, options: [String], state: PollState, answerChoices: [PollResult], correctAnswer: Int?, shouldPopViewController: Bool)
    func showNavigationBar()
}

class PollBuilderViewController: UIViewController {

    // MARK: View vars
    var bottomPaddingView: UIView!
    var buttonsView: UIView!
    var centerView: UIView!
    var dimmingView: UIView!
    var exitButton: UIButton!
    var mcPollBuilder: MCPollBuilderView!
    var createQuestionLabel: UILabel!
    var onboardingView: OnboardingView?
    var saveDraftButton: UIButton!
    var startPollButton: UIButton!
    var tapGestureRecognizer: UITapGestureRecognizer!
    var topPaddingView: UIView!
    
    // MARK: Data vars
    private let networking: Networking = URLSession.shared.request
    var answerChoices: [PollResult]!
    var canDraft: Bool!
    var correctAnswer: Int?
    var didLayoutSubviews = false
    var drafts: [Draft] = []
    var dropDownHidden: Bool = true
    var isFollowUpQuestion: Bool = false
    var isKeyboardShown: Bool = false
    var isOnboardingViewConfigured = false
    var loadedMCDraft: Draft?
    var shouldIgnoreNextKeyboardHiding: Bool = false
    var didLoad: Bool = false
    weak var delegate: PollBuilderViewControllerDelegate?
    
    // MARK: Constants
    let buttonHeight: CGFloat = 47.5
    let buttonsViewHeight: CGFloat = 67.5
    let centerViewHeight: CGFloat = 24
    let centerViewWidth: CGFloat = 135
    let createQuestionText = "Create Question"
    let draftsButtonWidth: CGFloat = 100
    let edgePadding: CGFloat = 18
    let editDraftModalSize: CGFloat = 50
    let errorText = "Error"
    let exitButtonImageName = "darkexit"
    let exitButtonPadding = 20
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
        self.modalPresentationCapturesStatusBarAppearance = true
        
        view.backgroundColor = .offWhite
        didLoad = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Add Keyboard Handlers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        
        setupViews()
        setupConstraints()
        getDrafts()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let onboardingView = onboardingView, didLayoutSubviews && !isOnboardingViewConfigured {
            isOnboardingViewConfigured = true
            let mcPollBuilderCVFrame = mcPollBuilder.collectionView.frame
            let collectionViewFrame = mcPollBuilder.convert(mcPollBuilderCVFrame, to: view)
            let circleImageXOffset: CGFloat = 12.0
            let circleImageYOffset: CGFloat = circleImageXOffset
            let circleImageFrame = CGRect(x: collectionViewFrame.origin.x + circleImageXOffset, y: collectionViewFrame.origin.y + circleImageYOffset, width: collectionViewFrame.width, height: collectionViewFrame.height)
            onboardingView.configure(with: circleImageFrame)
        }
        didLayoutSubviews = true
    }
    
    // MARK: - Layout
    func setupViews() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.navigationBar.barStyle = .black
        
        exitButton = UIButton()
        exitButton.setImage(UIImage(named: exitButtonImageName), for: .normal)
        exitButton.imageEdgeInsets = LayoutConstants.buttonImageInsets
        exitButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
        view.addSubview(exitButton)
        
        centerView = UIView()
        view.addSubview(centerView)
        
        mcPollBuilder = MCPollBuilderView()
        mcPollBuilder.configure(with: self, pollBuilderDelegate: self)
        view.addSubview(mcPollBuilder)

        createQuestionLabel = UILabel()
        createQuestionLabel.text = createQuestionText
        createQuestionLabel.font = ._20BoldFont
        createQuestionLabel.textAlignment = .center
        createQuestionLabel.textColor = .clickerBlack0
        view.addSubview(createQuestionLabel)
        
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
        startPollButton.backgroundColor = .polloGreen
        startPollButton.layer.cornerRadius = buttonHeight / 2
        startPollButton.addTarget(self, action: #selector(startPoll), for: .touchUpInside)
        buttonsView.addSubview(startPollButton)
        
        bottomPaddingView = UIView()
        bottomPaddingView.backgroundColor = .white
        view.addSubview(bottomPaddingView)

        let displayedOnboarding = UserDefault.getBoolValue(for: UserDefault.Keys.displayOnboarding)
        if !displayedOnboarding {
            onboardingView = OnboardingView()
            view.addSubview(onboardingView!)
            UserDefault.set(value: true, for: UserDefault.Keys.displayOnboarding)
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

    func setupConstraints() {
        exitButton.snp.makeConstraints { make in
            make.left.equalTo(edgePadding - LayoutConstants.buttonImageInsets.left)
            make.top.equalTo(edgePadding - LayoutConstants.buttonImageInsets.top)
            make.size.equalTo(LayoutConstants.buttonSize)
        }

        createQuestionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(edgePadding)
        }

        centerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(exitButton.snp.centerY)
            make.width.equalTo(centerViewWidth)
            make.height.equalTo(centerViewHeight)
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
            make.top.equalTo(exitButton.snp.bottom).offset(exitButtonPadding)
            make.bottom.equalTo(buttonsView.snp.top)
        }
        
        bottomPaddingView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(buttonsView.snp.bottom)
        }

        if let onboardingView = onboardingView {
            onboardingView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
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
        if !didLoad {
            print("warning! cannot save as draft before viewDidLoad")
            return
        }

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
        self.updateCanDraft(false)
        Analytics.shared.log(with: CreatedDraftPayload())
    }
    
    @objc func startPoll() {
        // MULTIPLE CHOICE
        if !didLoad {
            print("cannot start question before viewdidload")
            return
        }

        delegate?.showNavigationBar()
        dismiss(animated: true, completion: nil)
        hideKeyboard()
        

        answerChoices = mcPollBuilder.getChoices()
        let question = mcPollBuilder.questionText ?? ""
        delegate?.startPoll(text: question, options: mcPollBuilder.getOptions(), state: .live, answerChoices: answerChoices, correctAnswer: correctAnswer, shouldPopViewController: true)


        if loadedMCDraft != nil {
            Analytics.shared.log(with: CreatedPollFromDraftPayload())
            editDraftViewControllerDidTapDeleteDraftButton(draft: loadedMCDraft!)
        } else {
            Analytics.shared.log(with: CreatedPollPaylod())
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
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
    }
    
    // MARK: - KEYBOARD
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
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
        if (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue != nil {
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
