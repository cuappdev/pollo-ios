//
//  CardController.swift
//  Clicker
//
//  Created by eoin on 4/15/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import Presentr

enum CardType {
    case live
    case ended
    case shared
}

protocol EndPollDelegate {
    func endedPoll()
}


class CardController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, StartPollDelegate, EndPollDelegate, SocketDelegate {
    
    // name vars
    var nameView: NameView!
    
    // empty views
    var monkeyView: UIImageView!
    var nothingToSeeLabel: UILabel!
    var waitingLabel: UILabel!
    var createPollButton: UIButton!
    
    // nonempty views
    var zoomOutButton: UIButton!
    var mainCollectionView: UICollectionView!
    let askedIdentifer = "askedCardID"
    let answerIdentifier = "answerCardID"
    let dateIdentifier = "dateCardID"
    var verticalCollectionView: UICollectionView!
    var countLabel: UILabel!
    
    // nav bar
    var navigationTitleView: NavigationTitleView!
    var peopleButton: UIButton!
    
    var pinchRecognizer: UIPinchGestureRecognizer!
    
    var userRole: UserRole!
    var socket: Socket!
    var session: Session!
    var datePollsArr: [(String, [Poll])] = []
    var currentPolls: [Poll] = []
    var currentDatePollsIndex: Int!
    
    init(session: Session, userRole: UserRole) {
        super.init(nibName: nil, bundle: nil)
        
        self.socket = Socket(id: "\(session.id)", userType: userRole.rawValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clickerDeepBlack
        pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(detectedPinchAction))
        view.addGestureRecognizer(pinchRecognizer)
        
        socket.addDelegate(self)
        setupHorizontalNavBar()
        if (datePollsArr.count == 0) {
            setupEmpty()
        } else {
            currentDatePollsIndex = datePollsArr.count - 1
            currentPolls = datePollsArr[currentDatePollsIndex].1
            setupCards()
        }
        if (userRole == .admin && session.name == session.code) {
            setupName()
        }
    }
   
    // MARK - NAME THE POLL
    func setupName() {
        nameView = NameView()
        nameView.sessionId = session.id
        nameView.code = session.code
        nameView.name = session.name
        nameView.delegate = self
        view.addSubview(nameView)

        setupNameConstraints()
    }
    
    func updateNavBar() {
        navigationTitleView.updateViews(name: session.name, code: session.code)
    }
    
    func setupNameConstraints() {
        nameView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    @objc func createPollBtnPressed() {
        let pollBuilderVC = PollBuilderViewController()
        pollBuilderVC.startPollDelegate = self
        let nc = UINavigationController(rootViewController: pollBuilderVC)
        let presenter = Presentr(presentationType: .fullScreen)
        presenter.backgroundOpacity = 0.6
        presenter.roundCorners = true
        presenter.cornerRadius = 15
        presenter.dismissOnSwipe = true
        presenter.dismissOnSwipeDirection = .bottom
        customPresentViewController(presenter, viewController: nc, animated: true, completion: nil)
    }
    
    func setupEmpty() {
        setupEmptyViews()
        setupEmptyConstraints()
    }
    
    func removeEmptyState() {
        monkeyView.removeFromSuperview()
        nothingToSeeLabel.removeFromSuperview()
        waitingLabel.removeFromSuperview()
    }
    
    func setupEmptyViews() {
        monkeyView = UIImageView(image: #imageLiteral(resourceName: "monkey_emoji"))
        monkeyView.contentMode = .scaleAspectFit
        view.addSubview(monkeyView)
        
        nothingToSeeLabel = UILabel()
        nothingToSeeLabel.font = ._16SemiboldFont
        nothingToSeeLabel.textColor = .clickerBorder
        nothingToSeeLabel.textAlignment = .center
        view.addSubview(nothingToSeeLabel)
        
        waitingLabel = UILabel()
        waitingLabel.font = ._14MediumFont
        waitingLabel.textColor = .clickerMediumGrey
        waitingLabel.textAlignment = .center
        waitingLabel.lineBreakMode = .byWordWrapping
        waitingLabel.numberOfLines = 0
        view.addSubview(waitingLabel)
        
        if (userRole == .admin) {
            setupAdminEmpty()
        } else {
            setupMemberEmpty()
        }
    }
    
    func setupAdminEmpty() {
        nothingToSeeLabel.text = "Nothing to see here."
        
        waitingLabel.text = "You haven't asked any polls yet!\nTry it out below."
        
    }
    
    func setupMemberEmpty() {
        nothingToSeeLabel.text = "Nothing to see yet."
        
        waitingLabel.text = "Waiting for the host to post a poll."
    }
    
    func setupEmptyConstraints() {
        monkeyView.snp.makeConstraints { make in
            make.width.equalTo(31)
            make.height.equalTo(34)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(142)
        }
        
        nothingToSeeLabel.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(19)
            make.centerX.equalToSuperview()
            make.top.equalTo(monkeyView.snp.bottom).offset(21)
        }
        
        waitingLabel.snp.makeConstraints { make in
            make.width.equalTo(220)
            make.height.equalTo(36)
            make.centerX.equalToSuperview()
            make.top.equalTo(nothingToSeeLabel.snp.bottom).offset(11)
        }
    }
    
    func setupCards() {
        setupCardsViews()
        setupCardsConstraints()
    }
    
    func setupCardsViews() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        let collectionViewInset = view.frame.width * 0.05
        mainCollectionView.contentInset = UIEdgeInsetsMake(0, collectionViewInset, 0, collectionViewInset)
        mainCollectionView.register(AskedCard.self, forCellWithReuseIdentifier: askedIdentifer)
        mainCollectionView.register(AnswerCard.self, forCellWithReuseIdentifier: answerIdentifier)
        mainCollectionView.showsVerticalScrollIndicator = false
        mainCollectionView.showsHorizontalScrollIndicator = false
        mainCollectionView.alwaysBounceHorizontal = true
        mainCollectionView.backgroundColor = .clear
        mainCollectionView.isPagingEnabled = true
        view.addSubview(mainCollectionView)
        
        zoomOutButton = UIButton()
        zoomOutButton.setImage(#imageLiteral(resourceName: "zoomout"), for: .normal)
        zoomOutButton.addTarget(self, action: #selector(zoomOutBtnPressed), for: .touchUpInside)
        view.addSubview(zoomOutButton)
        
        countLabel = UILabel()
        let countString = "1/\(currentPolls.count)"
        countLabel.attributedText = getCountLabelAttributedString(countString)
        countLabel.textAlignment = .center
        countLabel.backgroundColor = UIColor.clickerLabelGrey
        countLabel.layer.cornerRadius = 12
        countLabel.clipsToBounds = true
        view.addSubview(countLabel)
    }

    func setupCardsConstraints() {
        zoomOutButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.width.height.equalTo(20)
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalTo(zoomOutButton.snp.centerY)
            make.centerX.equalToSuperview()
            make.width.equalTo(42)
            make.height.equalTo(23)
        }
        
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(6)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Vertical Collection View
    func setupVertical() {
        mainCollectionView.removeFromSuperview()
        zoomOutButton.removeFromSuperview()
        countLabel.removeFromSuperview()
        
        setupVerticalNavBar()
        setupVerticalCollectionView()
    }
    
    func setupVerticalCollectionView() {
        let layout = UICollectionViewFlowLayout()
        verticalCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        verticalCollectionView.delegate = self
        verticalCollectionView.dataSource = self
        verticalCollectionView.register(CardDateCell.self, forCellWithReuseIdentifier: dateIdentifier)
        verticalCollectionView.showsVerticalScrollIndicator = false
        verticalCollectionView.showsHorizontalScrollIndicator = false
        verticalCollectionView.alwaysBounceVertical = true
        verticalCollectionView.backgroundColor = .clear
        verticalCollectionView.isPagingEnabled = true
        view.addSubview(verticalCollectionView)
        view.sendSubview(toBack: verticalCollectionView)
        
        verticalCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupVerticalNavBar() {
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.titleView = UIView()
        self.navigationItem.rightBarButtonItems = []
    }
    
    func revertToHorizontal() {
        verticalCollectionView.removeFromSuperview()
        setupCards()
        setupHorizontalNavBar()
    }

    // MARK: Get CardType
    func getCardType(from poll: Poll) -> CardType {
        if (poll.isLive) {
            return .live
        } else if (poll.isShared) {
            return .shared
        } else {
            return .ended
        }
    }
    
    // MARK: UPDATE DATE POLLS ARRAY
    func updateDatePollsArr() {
        GetSortedPolls(id: session.id).make()
            .done { datePollsArr in
                self.datePollsArr = datePollsArr
                self.currentPolls = datePollsArr[self.currentDatePollsIndex].1
                DispatchQueue.main.async { self.mainCollectionView.reloadData() }
            }.catch { error in
                print(error)
        }
    }
    
    // MARK: SCROLLVIEW METHODS
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView != mainCollectionView) {
            return
        }
        for cell in mainCollectionView.visibleCells {
            let indexPath = mainCollectionView.indexPath(for: cell)
            // Get cell frame
            guard let cellRect = mainCollectionView.layoutAttributesForItem(at: indexPath!)?.frame else {
                return
            }
            // Check if cell is fully visible
            if (mainCollectionView.bounds.contains(cellRect)) {
                let countString = "\(indexPath!.item + 1)/\(currentPolls.count)"
                countLabel.attributedText = getCountLabelAttributedString(countString)
                break
            }
        }
    }
    
    // MARK: GET COUNT LABEL TEXT
    func getCountLabelAttributedString(_ countString: String) -> NSMutableAttributedString {
        let slashIndex = countString.index(of: "/")?.encodedOffset
        let attributedString = NSMutableAttributedString(string: countString, attributes: [
            .font: UIFont.systemFont(ofSize: 14.0, weight: .bold),
            .foregroundColor: UIColor.clickerMediumGrey,
            .kern: 0.0
            ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(white: 1.0, alpha: 0.9), range: NSRange(location: 0, length: slashIndex!))
        return attributedString
    }
    
    // MARK - SOCKET DELEGATE
    
    func sessionConnected() { }
    
    func sessionDisconnected() { }
    
    func receivedUserCount(_ count: Int) {
        peopleButton.setTitle("\(count)", for: .normal)
    }
    
    func pollStarted(_ poll: Poll) {
        if (userRole == .member) {
            let arrEmpty = (datePollsArr.count == 0)
            appendPoll(poll: poll)
            if (!arrEmpty) {
                self.mainCollectionView.reloadData()
                let lastIndexPath = IndexPath(item: self.currentPolls.count - 1, section: 0)
                self.mainCollectionView.scrollToItem(at: lastIndexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    func pollEnded(_ poll: Poll) { }
    
    func receivedResults(_ currentState: CurrentState) { }
    
    func saveSession(_ session: Session) { }
    
    func updatedTally(_ currentState: CurrentState) { }
    
    func appendPoll(poll: Poll) {
        if (datePollsArr.count == 0) {
            self.datePollsArr.append((getTodaysDate(), [poll]))
            self.currentDatePollsIndex = 0
            removeEmptyState()
            setupCards()
        } else {
            self.datePollsArr[currentDatePollsIndex].1.append(poll)
        }
        self.currentPolls = self.datePollsArr[currentDatePollsIndex].1
    }
    
    // MARK: - START POLL DELEGATE
    func startPoll(text: String, type: String, options: [String], isShared: Bool) {
        // EMIT START QUESTION
        let socketQuestion: [String:Any] = [
            "text": text,
            "type": type,
            "options": options,
            "shared": isShared
        ]
        socket.socket.emit("server/poll/start", with: [socketQuestion])
        let questionType: QuestionType = (type == "MULTIPLE_CHOICE") ? .multipleChoice : .freeResponse
        let newPoll = Poll(text: text, options: options, type: questionType, isLive: true, isShared: isShared)
        let arrEmpty = (datePollsArr.count == 0)
        appendPoll(poll: newPoll)
        // DISABLE CREATE POLL BUTTON
        createPollButton.isUserInteractionEnabled = false
        DispatchQueue.main.async {
            if (!arrEmpty) {
                self.mainCollectionView.reloadData()
            }
            let lastIndexPath = IndexPath(item: self.currentPolls.count - 1, section: 0)
            self.mainCollectionView.scrollToItem(at: lastIndexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    // MARK: ENDED POLL DELEGATE
    func endedPoll() {
        // ENABLE CREATE POLL BUTTON
        createPollButton.isUserInteractionEnabled = true
    }
    
    func setupHorizontalNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        // REMOVE BOTTOM SHADOW
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationTitleView = NavigationTitleView()
        navigationTitleView.updateViews(name: session.name, code: session.code)
        navigationTitleView.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        self.navigationItem.titleView = navigationTitleView
        
        let backImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(goBack))
        
        
        peopleButton = UIButton()
        peopleButton.setImage(#imageLiteral(resourceName: "person"), for: .normal)
        peopleButton.setTitle("0", for: .normal)
        peopleButton.titleLabel?.font = UIFont._16RegularFont
        peopleButton.sizeToFit()
        let peopleBarButton = UIBarButtonItem(customView: peopleButton)
        
        if (userRole == .admin) {
            createPollButton = UIButton()
            createPollButton.setImage(#imageLiteral(resourceName: "whiteCreatePoll"), for: .normal)
            createPollButton.addTarget(self, action: #selector(createPollBtnPressed), for: .touchUpInside)
            let createPollBarButton = UIBarButtonItem(customView: createPollButton)
            self.navigationItem.rightBarButtonItems = [createPollBarButton, peopleBarButton]
        } else {
            self.navigationItem.rightBarButtonItems = [peopleBarButton]
        }
    }
    
    
    // MARK: ACTIONS
    @objc func goBack() {
        socket.socket.disconnect()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func zoomOutBtnPressed() {
        // SETUP VERTICAL VIEW
        setupVertical()
    }
    
    @objc func detectedPinchAction(_ sender: UIPinchGestureRecognizer) {
        print(sender.scale)
        let isPinchOut: Bool = (sender.scale > 1)
        if (isPinchOut && verticalCollectionView != nil && !verticalCollectionView.isDescendant(of: self.view)) {
            zoomOutBtnPressed()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // HIDE NAV BAR, SHOW TABBAR
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
