//
//  PollsViewController.swift
//  Clicker
//
//  Created by eoin on 4/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import GoogleSignIn
import IGListKit
import Presentr
import UIKit

class PollsViewController: UIViewController {
    
    // MARK: - View vars
    var pollsOptionsView: OptionsView!
    var pollsCollectionView: UICollectionView!
    var adapter: ListAdapter!
    var titleLabel: UILabel!
    var newGroupButton: UIButton!
    var newGroupActivityIndicatorView: UIActivityIndicatorView!
    var bottomPaddingView: UIView!
    var joinSessionContainerView: UIView!
    var codeTextField: UITextField!
    var joinSessionButton: UIButton!
    var settingsButton: UIButton!
    var tapGestureRecognizer: UITapGestureRecognizer!
    var dimmingView: UIView!
    var headerGradientView: UIView!
    
    // MARK: - Data vars
    var pollTypeModels: [PollTypeModel]!
    var isKeyboardShown: Bool = false
    var isOpeningGroup: Bool = false
    var isListeningToKeyboard: Bool = true
    var gradientNeedsSetup: Bool = true
    var session: Session?
    
    // MARK: - Constants
    let newGroupButtonLength: CGFloat = 29
    let buttonPadding: CGFloat = 15
    let popupViewHeight: CGFloat = 140
    let editModalHeight: CGFloat = 205
    let joinSessionContainerViewHeight: CGFloat = 64
    let codeTextFieldEdgePadding: CGFloat = 18
    let codeTextFieldHeight: CGFloat = 40
    let codeTextFieldHorizontalPadding: CGFloat = 12
    let headerGradientHeight: CGFloat = 186
    let titleLabelText = "Pollo"
    let joinSessionButtonAnimationDuration: TimeInterval = 0.2
    let createdPollsOptionsText = "Created"
    let joinedPollsOptionsText = "Joined"
    let codeTextFieldPlaceHolder = "Enter a code..."
    let joinSessionButtonTitle = "Join"
    let errorText = "Error"
    let failedToCreateGroupText = "Failed to create new group. Try again!"
    let submitFeedbackTitle = "Submit Feedback"
    let submitFeedbackMessage = "You can help us make our app even better! Tap below to submit feedback."
    
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

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
        titleLabel.font = ._30HeavyFont
        titleLabel.textColor = .clickerBlack1
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
        view.addSubview(newGroupButton)
        
        settingsButton = UIButton()
        settingsButton.setImage(#imageLiteral(resourceName: "black_settings"), for: .normal)
        settingsButton.imageEdgeInsets = LayoutConstants.buttonImageInsets
        settingsButton.addTarget(self, action: #selector(settingsAction), for: .touchUpInside)
        view.addSubview(settingsButton)
        
        newGroupActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        newGroupActivityIndicatorView.isHidden = true
        newGroupActivityIndicatorView.isUserInteractionEnabled = false
        view.addSubview(newGroupActivityIndicatorView)
        
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0
        view.addSubview(dimmingView)
        
        joinSessionContainerView = UIView()
        joinSessionContainerView.backgroundColor = .clickerBlack1
        view.addSubview(joinSessionContainerView)
        
        joinSessionButton = UIButton()
        joinSessionButton.setTitle(joinSessionButtonTitle, for: .normal)
        joinSessionButton.setTitleColor(.white, for: .normal)
        joinSessionButton.titleLabel?.font = ._16SemiboldFont
        joinSessionButton.titleLabel?.textAlignment = .center
        joinSessionButton.backgroundColor = .clickerGrey2
        joinSessionButton.layer.cornerRadius = codeTextFieldHeight / 2
        joinSessionButton.addTarget(self, action: #selector(joinSession), for: .touchUpInside)
        joinSessionButton.alpha = 0.5
        view.addSubview(joinSessionButton)
        
        codeTextField = UITextField()
        codeTextField.delegate = self
        codeTextField.layer.cornerRadius = codeTextFieldHeight / 2
        codeTextField.borderStyle = .none
        codeTextField.font = ._16MediumFont
        codeTextField.backgroundColor = .clickerGrey12
        codeTextField.addTarget(self, action: #selector(didStartTyping), for: .editingChanged)
        codeTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: codeTextFieldEdgePadding, height: codeTextFieldHeight))
        codeTextField.leftViewMode = .always
        codeTextField.rightView = joinSessionButton
        codeTextField.rightViewMode = .always
        codeTextField.attributedPlaceholder = NSAttributedString(string: codeTextFieldPlaceHolder, attributes: [NSAttributedStringKey.foregroundColor: UIColor.clickerGrey13, NSAttributedStringKey.font: UIFont._16MediumFont])
        codeTextField.textColor = .white
        codeTextField.autocapitalizationType = .allCharacters
        joinSessionContainerView.addSubview(codeTextField)
        
        bottomPaddingView = UIView()
        bottomPaddingView.backgroundColor = .clickerBlack1
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
        return networking(Endpoint.generateCode()).decode(Response<Code>.self)
    }
    
    func startSession(code: String, name: String, isGroup: Bool) -> Future<Response<Node<Session>>> {
        return networking(Endpoint.startSession(code: code, name: name, isGroup: isGroup)).decode(Response<Node<Session>>.self)
    }
    
    // MARK: - Actions
    @objc func newGroupAction() {
        displayNewGroupActivityIndicatorView()
        
        generateCode().chained { codeResponse -> Future<Response<Node<Session>>> in
            let code = codeResponse.data.code
            return self.startSession(code: code, name: code, isGroup: false)
        }.observe { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .value(let sessionResponse):
                    let session = sessionResponse.data.node
                    if let this = self {
                        this.isListeningToKeyboard = false
                        this.hideNewGroupActivityIndicatorView()
                        let pollsDateViewController = PollsDateViewController(delegate: this, pollsDateArray: [], session: session, userRole: .admin)
                        this.navigationController?.pushViewController(pollsDateViewController, animated: true)
                        this.navigationController?.setNavigationBarHidden(false, animated: true)
                        Analytics.shared.log(with: CreatedGroupPayload())
                    }
                case .error(let error):
                    print(error)
                    if let this = self {
                        this.hideNewGroupActivityIndicatorView()
                        let alertController = this.createAlert(title: this.errorText, message: this.failedToCreateGroupText)
                        this.present(alertController, animated: true, completion: nil)
                    }
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
    
    func joinSessionWithCode(with code: String) -> Future<Response<Node<Session>>> {
        return networking(Endpoint.joinSessionWithCode(with: code)).decode(Response<Node<Session>>.self)
    }
    
    func getSortedPolls(with id: Int) -> Future<Response<[PollsDateModel]>> {
        return networking(Endpoint.getSortedPolls(with: id)).decode(Response<[PollsDateModel]>.self)
    }
    
    @objc func joinSession() {
        guard let code = codeTextField.text, code != "" else { return }
        joinSessionWithCode(with: code).chained { sessionResponse -> Future<Response<[PollsDateModel]>> in
            self.session = sessionResponse.data.node
            return self.getSortedPolls(with: sessionResponse.data.node.id)
        }.observe { [weak self] result in
            switch result {
            case .value(let pollsResponse):
                let pollsDateArray = pollsResponse.data
                DispatchQueue.main.async {
                    if let this = self, let session = this.session {
                        this.codeTextField.text = ""
                        let pollsDateViewController = PollsDateViewController(delegate: this, pollsDateArray: pollsDateArray, session: session, userRole: .member)
                        this.updateJoinSessionButton(canJoin: false)
                        this.navigationController?.pushViewController(pollsDateViewController, animated: true)
                        this.navigationController?.setNavigationBarHidden(false, animated: true)
                        Analytics.shared.log(with: JoinedGroupPayload())
                    }
                }
            case .error(let error):
                print(error)
                if let this = self {
                    let alertController = this.createAlert(title: this.errorText, message: "Failed to join session with code \(code). Try again!")
                    this.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func updateJoinSessionButton(canJoin: Bool) {
        UIView.animate(withDuration: joinSessionButtonAnimationDuration) {
            self.joinSessionButton.backgroundColor = canJoin ? .clickerGreen0 : .clickerGrey2
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
            updateJoinSessionButton(canJoin: text.count == 6)
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
    
    func joinSessionWithIdAndCode(id: Int, code: String) -> Future<Response<Node<Session>>> {
        return networking(Endpoint.joinSessionWithIdAndCode(id: id, code: code)).decode(Response<Node<Session>>.self)
    }
    
    func getPollSessions(with role: UserRole) -> Future<Response<[Session]>> {
        return networking(Endpoint.getPollSessions(with: role)).decode(Response<[Session]>.self)
    }
    
    // MARK: - Helpers
    func reloadSessions(for userRole: UserRole, completion: (([Session]) -> Void)?) {
        getPollSessions(with: userRole).observe { result in
            switch result {
            case .value(let response):
                let sessions = response.data
                completion?(sessions)
            case .error(let error):
                print(error)
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
        newGroupButton?.isEnabled = true
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
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
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
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
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
    open override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let alert = createAlert(title: submitFeedbackTitle, message: submitFeedbackMessage)
            alert.addAction(UIAlertAction(title: submitFeedbackTitle, style: .default, handler: { action in
                self.isListeningToKeyboard = false
                let feedbackVC = FeedbackViewController(type: .pollsViewController)
                self.navigationController?.pushViewController(feedbackVC, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
