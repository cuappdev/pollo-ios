//
//  PollsViewController.swift
//  Pollo
//
//  Created by eoin on 4/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import FutureNova
import GoogleSignIn
import IGListKit
import Presentr
import StoreKit
import UIKit

class PollsViewController: UIViewController {
    
    // MARK: - View vars
    var adapter: ListAdapter!
    var bottomPaddingView: UIView!
    var codeTextField: UITextField!
    var dimmingView: UIView!
    var headerGradientView: UIView!
    var joinSessionButton: UIButton!
    var joinSessionContainerView: UIView!
    var newGroupActivityIndicatorView: UIActivityIndicatorView!
    var newGroupButton: UIButton!
    var pollsCollectionView: UICollectionView!
    var pollsOptionsView: OptionsView!
    var settingsButton: UIButton!
    var tapGestureRecognizer: UITapGestureRecognizer!
    var titleLabel: UILabel!
    
    // MARK: - Data vars
    private let networking: Networking = URLSession.shared.request
    var gradientNeedsSetup: Bool = true
    var isKeyboardShown: Bool = false
    var isListeningToKeyboard: Bool = true
    var isOpeningGroup: Bool = false
    var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
    var pollTypeModels: [PollTypeModel]!
    var session: Session?
    
    // MARK: - Constants
    let buttonPadding: CGFloat = 15
    let codeTextFieldEdgePadding: CGFloat = 18
    let codeTextFieldHeight: CGFloat = 40
    let codeTextFieldHorizontalPadding: CGFloat = 12
    let codeTextFieldPlaceHolder = "Enter a group code..."
    let createdPollsOptionsText = "Created"
    let editModalHeight: CGFloat = 205
    let errorText = "Error"
    let failedToCreateGroupText = "Failed to create new group. Try again!"
    let headerGradientHeight: CGFloat = 186
    let joinSessionButtonAnimationDuration: TimeInterval = 0.2
    let joinSessionButtonTitle = "Join"
    let joinSessionContainerViewHeight: CGFloat = 64
    let joinSessionFailureMessage = "We couldn't find a group with that code. Please try again."
    let joinedPollsOptionsText = "Joined"
    let newGroupButtonLength: CGFloat = 29
    let popupViewHeight: CGFloat = 140
    let submitFeedbackMessage = "You can help us make our app even better! Tap below to submit feedback."
    let submitFeedbackTitle = "Submit Feedback"
    let titleLabelText = "Pollo"
    
    init(joinedSessions: [Session], createdSessions: [Session]) {
        super.init(nibName: nil, bundle: nil)
        let joinedPollTypeModel = PollTypeModel(pollType: .joined, sessions: joinedSessions)
        let createdPollTypeModel = PollTypeModel(pollType: .created, sessions: createdSessions)
        pollTypeModels = [joinedPollTypeModel, createdPollTypeModel]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clickerGrey8

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        promptUserReview()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Configure
    func configure(joinedSessions: [Session], createdSessions: [Session]) {
        let joinedPollTypeModel = PollTypeModel(pollType: .joined, sessions: joinedSessions)
        let createdPollTypeModel = PollTypeModel(pollType: .created, sessions: createdSessions)
        pollTypeModels = [joinedPollTypeModel, createdPollTypeModel]
        DispatchQueue.main.async {
            self.adapter.performUpdates(animated: true, completion: nil)
        }
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        headerGradientView = UIView()
        view.addSubview(headerGradientView)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)

        titleLabel = UILabel()
        titleLabel.text = titleLabelText
        titleLabel.font = ._30BoldFont
        titleLabel.textColor = .darkestGrey
        view.addSubview(titleLabel)
        
        pollsOptionsView = OptionsView(frame: .zero, options: [joinedPollsOptionsText, createdPollsOptionsText], sliderBarDelegate: self)
        view.addSubview(pollsOptionsView)
        
        let layout = UICollectionViewFlowLayout()
        pollsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        pollsCollectionView.bounces = false
        pollsCollectionView.showsVerticalScrollIndicator = false
        pollsCollectionView.showsHorizontalScrollIndicator = false
        pollsCollectionView.backgroundColor = .clickerGrey4
        pollsCollectionView.isPagingEnabled = true
        view.addSubview(pollsCollectionView)
        
        let updater: ListAdapterUpdater = ListAdapterUpdater()
        adapter = ListAdapter(updater: updater, viewController: self)
        adapter.collectionView = pollsCollectionView
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        
        newGroupButton = UIButton()
        newGroupButton.setImage(#imageLiteral(resourceName: "create_poll"), for: .normal)
        newGroupButton.imageEdgeInsets = LayoutConstants.buttonImageInsets
        newGroupButton.addTarget(self, action: #selector(newGroupAction), for: .touchUpInside)
        newGroupButton.isHidden = pollsOptionsView.isJoined
        view.addSubview(newGroupButton)
        
        settingsButton = UIButton()
        settingsButton.setImage(#imageLiteral(resourceName: "black_settings"), for: .normal)
        settingsButton.imageEdgeInsets = LayoutConstants.buttonImageInsets
        settingsButton.addTarget(self, action: #selector(settingsAction), for: .touchUpInside)
        view.addSubview(settingsButton)
        
        newGroupActivityIndicatorView = UIActivityIndicatorView(style: .gray)
        newGroupActivityIndicatorView.isHidden = true
        newGroupActivityIndicatorView.isUserInteractionEnabled = false
        view.addSubview(newGroupActivityIndicatorView)
        
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0
        view.addSubview(dimmingView)
        
        joinSessionContainerView = UIView()
        joinSessionContainerView.backgroundColor = .darkestGrey
        view.addSubview(joinSessionContainerView)
        
        joinSessionButton = UIButton()
        joinSessionButton.setTitle(joinSessionButtonTitle, for: .normal)
        joinSessionButton.setTitleColor(.white, for: .normal)
        joinSessionButton.titleLabel?.font = ._16SemiboldFont
        joinSessionButton.titleLabel?.textAlignment = .center
        joinSessionButton.backgroundColor = .blueGrey
        joinSessionButton.layer.cornerRadius = codeTextFieldHeight / 2
        joinSessionButton.addTarget(self, action: #selector(joinSession), for: .touchUpInside)
        joinSessionButton.alpha = 0.5
        view.addSubview(joinSessionButton)
        
        codeTextField = UITextField()
        codeTextField.delegate = self
        codeTextField.layer.cornerRadius = codeTextFieldHeight / 2
        codeTextField.borderStyle = .none
        codeTextField.font = ._16SemiboldFont
        codeTextField.backgroundColor = .clickerGrey12
        codeTextField.addTarget(self, action: #selector(didStartTyping), for: .editingChanged)
        codeTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: codeTextFieldEdgePadding, height: codeTextFieldHeight))
        codeTextField.leftViewMode = .always
        codeTextField.rightView = joinSessionButton
        codeTextField.rightViewMode = .always
        codeTextField.attributedPlaceholder = NSAttributedString(string: codeTextFieldPlaceHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.clickerGrey13, NSAttributedString.Key.font: UIFont._16SemiboldFont])
        codeTextField.textColor = .white
        codeTextField.autocapitalizationType = .allCharacters
        joinSessionContainerView.addSubview(codeTextField)
        
        bottomPaddingView = UIView()
        bottomPaddingView.backgroundColor = .darkestGrey
        view.addSubview(bottomPaddingView)
    }
    
    func setupConstraints() {
        headerGradientView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-1 * UIApplication.shared.statusBarFrame.size.height)
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width)
            make.height.equalTo(headerGradientHeight + UIApplication.shared.statusBarFrame.size.height)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(headerGradientView.snp.centerY).multipliedBy(1.2)
            make.centerX.equalToSuperview()
            make.height.equalTo(35.5)
        }
        
        pollsOptionsView.snp.makeConstraints { make in
            make.bottom.equalTo(headerGradientView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        dimmingView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        joinSessionContainerView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.width.centerX.equalToSuperview()
            make.height.equalTo(joinSessionContainerViewHeight)
        }

        joinSessionButton.snp.makeConstraints { make in
            make.width.equalTo(83.5)
            make.height.equalTo(codeTextFieldHeight)
        }
        
        codeTextField.snp.makeConstraints { make in
            make.height.equalTo(codeTextFieldHeight)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(codeTextFieldHorizontalPadding)
            make.trailing.equalToSuperview().inset(codeTextFieldHorizontalPadding)
        }
        
        bottomPaddingView.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(joinSessionContainerView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        pollsCollectionView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(joinSessionContainerViewHeight)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(pollsOptionsView.snp.bottom)
        }
        
        newGroupActivityIndicatorView.snp.makeConstraints { make in
            make.top.equalTo(newGroupButton.snp.top)
            make.width.equalTo(newGroupButton.snp.width)
            make.height.equalTo(newGroupButton.snp.height)
            make.trailing.equalTo(newGroupButton.snp.trailing)
        }
        
        newGroupButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(buttonPadding - LayoutConstants.buttonImageInsets.top)
            make.right.equalToSuperview().inset(buttonPadding - LayoutConstants.buttonImageInsets.right)
            make.size.equalTo(LayoutConstants.buttonSize)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.top.equalTo(newGroupButton.snp.top)
            make.left.equalToSuperview().offset(buttonPadding - LayoutConstants.buttonImageInsets.left)
            make.size.equalTo(LayoutConstants.buttonSize)
        }
    }
    
    func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = headerGradientView.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.clickerGrey7.cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        headerGradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func generateCode() -> Future<Response<Code>> {
        return networking(Endpoint.generateCode()).decode()
    }
    
    func startSession(code: String, name: String, isGroup: Bool) -> Future<Response<Session>> {
        return networking(Endpoint.startSession(code: code, name: name, isGroup: isGroup)).decode()
    }
    
    func promptUserReview() {
        Ratings.shared.updateNumAppLaunches()
        Ratings.shared.promptReview()
    }
    
    // MARK: - Actions
    @objc func newGroupAction() {
        displayNewGroupActivityIndicatorView()
        
        generateCode().chained { codeResponse -> Future<Response<Session>> in
            let code = codeResponse.data.code
            return self.startSession(code: code, name: code, isGroup: false)
        }.observe { [weak self] result in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .value(let sessionResponse):
                    let session = sessionResponse.data
                    session.isLive = false
                    self.isListeningToKeyboard = false
                    self.hideNewGroupActivityIndicatorView()
                    let pollsDateViewController = PollsDateViewController(delegate: self, pollsDateArray: [], session: session, userRole: .admin)
                    self.navigationController?.pushViewController(pollsDateViewController, animated: true)
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    Analytics.shared.log(with: CreatedGroupPayload())
                case .error(let error):
                    print(error)
                    self.hideNewGroupActivityIndicatorView()
                    let alertController = self.createAlert(title: self.errorText, message: self.failedToCreateGroupText)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func displayNewGroupActivityIndicatorView() {
        newGroupButton.isHidden = true
        newGroupButton.isUserInteractionEnabled = false
        
        newGroupActivityIndicatorView.isHidden = false
        newGroupActivityIndicatorView.isUserInteractionEnabled = true
        newGroupActivityIndicatorView.startAnimating()
    }
    
    func hideNewGroupActivityIndicatorView() {
        newGroupActivityIndicatorView.stopAnimating()
        newGroupActivityIndicatorView.isHidden = true
        newGroupActivityIndicatorView.isUserInteractionEnabled = false
        
        newGroupButton.isHidden = false
        newGroupButton.isUserInteractionEnabled = true
    }
    
    func joinSessionWithCode(with code: String) -> Future<Data> {
        return networking(Endpoint.joinSessionWithCode(with: code))
    }
    
    func getSortedPolls(with id: Int) -> Future<Data> {
        return networking(Endpoint.getSortedPolls(with: id))
    }
    
    @objc func joinSession() {
        guard let code = codeTextField.text, code != "" else { return }
        joinSessionWithCode(with: code).chained { sessionData -> Future<Data> in
            if let sessionResponse = try? self.jsonDecoder.decode(Response<Session>.self, from: sessionData) {
                self.session = sessionResponse.data
                return self.getSortedPolls(with: sessionResponse.data.id)
            }
            // Fail out of get sorted polls call
            return self.getSortedPolls(with: -1)
        }.observe { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .value(let data):
                guard let pollsResponse = try? self.jsonDecoder.decode(Response<[GetSortedPollsResponse]>.self, from: data), pollsResponse.success else {
                    DispatchQueue.main.async {
                        let alertController = self.createAlert(title: self.errorText, message: self.joinSessionFailureMessage, actionTitle: "Okay")
                        self.present(alertController, animated: true, completion: nil)
                    }
                    return
                }
                DispatchQueue.main.async {
                    guard let session = self.session else { return }
                    var pollsDateArray = [PollsDateModel]()
                    pollsResponse.data.forEach { response in
                        var mutableResponse = response
                        if let index = pollsDateArray.firstIndex(where: { $0.dateValue.isSameDay(as: mutableResponse.dateValue)}) {
                            pollsDateArray[index].polls.append(contentsOf: response.polls)
                        } else {
                            response.polls.forEach { poll in
                                let polls = [Poll(text: poll.text, answerChoices: poll.answerChoices, type: poll.type, userAnswers: poll.userAnswers, state: poll.state)]
                                pollsDateArray.append(PollsDateModel(date: response.date, polls: polls))
                            }
                        }
                    }
                    
                    self.updateJoinSessionButton(canJoin: false)
                    let pollsDateViewController = PollsDateViewController(delegate: self, pollsDateArray: pollsDateArray.reversed(), session: session, userRole: .member)
                    self.navigationController?.pushViewController(pollsDateViewController, animated: true)
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    Analytics.shared.log(with: JoinedGroupPayload())
                }
            case .error(let error):
                print(error)
                DispatchQueue.main.async {
                    let alertController = self.createAlert(title: "Invalid code", message: self.joinSessionFailureMessage, actionTitle: "Okay")
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func updateJoinSessionButton(canJoin: Bool) {
        UIView.animate(withDuration: joinSessionButtonAnimationDuration) {
            self.joinSessionButton.backgroundColor = canJoin ? .polloGreen : .blueGrey
            self.joinSessionButton.alpha = canJoin ? 1.0 : 0.5
        }
    }
    
    @objc func settingsAction() {
        let settingsNavigationController = UINavigationController(rootViewController: SettingsViewController())
        self.present(settingsNavigationController, animated: true, completion: nil)
    }
    
    @objc func didStartTyping(_ textField: UITextField) {
        if let text = textField.text {
            textField.text = text.uppercased()
            updateJoinSessionButton(canJoin: text.count == IntegerConstants.validCodeLength)
        }
    }
    
    @objc func hideKeyboard() {
        // Hide keyboard when user taps outside of text field on popup view
        codeTextField.resignFirstResponder()
    }
    
    @objc func reduceOpacity(sender: UIButton) {
        UIView.animate(withDuration: 0.35) {
            sender.alpha = 0.7
        }
    }
    
    @objc func resetOpacity(sender: UIButton) {
        UIView.animate(withDuration: 0.35) {
            sender.alpha = 1
        }
    }
    
    func joinSessionWithIdAndCode(id: Int, code: String) -> Future<Response<Session>> {
        return networking(Endpoint.joinSessionWithIdAndCode(id: id, code: code)).decode()
    }
    
    func getPollSessions(with role: UserRole) -> Future<Response<[Session]>> {
        return networking(Endpoint.getPollSessions(with: role)).decode()
    }
    
    // MARK: - Helpers
    func reloadSessions(for userRole: UserRole, completion: (([Session]) -> Void)?) {
        getPollSessions(with: userRole).observe { result in
            DispatchQueue.main.async {
                switch result {
                case .value(let response):
                    var sessions = [Session]()
                    var auxiliaryDict = [Double: Session]()
                    response.data.forEach { session in
                        if let updatedAt = session.updatedAt, let latestActivityTimestamp = Double(updatedAt) {
                            auxiliaryDict[latestActivityTimestamp] = Session(id: session.id, name: session.name, code: session.code, latestActivity: getLatestActivity(latestActivityTimestamp: latestActivityTimestamp, code: session.code, role: userRole), isLive: session.isLive, isFilterActivated: session.isFilterActivated)
                        }
                    }
                    auxiliaryDict.keys.sorted().forEach { timestamp in
                        guard let session = auxiliaryDict[timestamp] else { return }
                        sessions.append(session)
                    }
                    completion?(sessions)
                case .error(let error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: - View lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.parent is UINavigationController {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        isListeningToKeyboard = true
        newGroupButton.isHidden = pollsOptionsView.isJoined
        isOpeningGroup = false
    }
    
    override func viewDidLayoutSubviews() {
        if gradientNeedsSetup {
            setupGradient() // needs headerGradientView to have been layed out, so it has a nonzero frame
            gradientNeedsSetup = false
        }
    }
    
    // MARK: - KEYBOARD
    @objc func keyboardWillShow(notification: NSNotification) {
        let hasPresentedViewController = self.presentedViewController != nil && !(self.presentedViewController is UIAlertController)
        if !isListeningToKeyboard || hasPresentedViewController { return }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let iphoneXBottomPadding = view.safeAreaInsets.bottom
            UIView.animate(withDuration: 0.5) {
                self.dimmingView.alpha = 1
            }
            joinSessionContainerView.snp.remakeConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(keyboardSize.height - iphoneXBottomPadding)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(joinSessionContainerViewHeight)
            }
            joinSessionContainerView.superview?.layoutIfNeeded()
            isKeyboardShown = true
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let hasPresentedViewController = self.presentedViewController != nil && !(self.presentedViewController is UIAlertController)
        if !isListeningToKeyboard || hasPresentedViewController { return }
        if (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue != nil {
            UIView.animate(withDuration: 0.5) {
                self.dimmingView.alpha = 0
            }
            joinSessionContainerView.snp.remakeConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(joinSessionContainerViewHeight)
            }
            joinSessionContainerView.superview?.layoutIfNeeded()
            isKeyboardShown = false
        }
    }

    // MARK: - Shake to send feedback
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let alert = createAlert(title: submitFeedbackTitle, message: submitFeedbackMessage)
            alert.addAction(UIAlertAction(title: submitFeedbackTitle, style: .default, handler: { _ in
                self.isListeningToKeyboard = false
                let feedbackVC = FeedbackViewController(type: .pollsViewController)
                self.navigationController?.pushViewController(feedbackVC, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
