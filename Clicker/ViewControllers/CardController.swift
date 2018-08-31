//
//  CardController.swift
//  Clicker
//
//  Created by eoin on 4/15/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit
import Presentr
import UIKit

enum CardType {
    case live
    case ended
    case shared
}

enum CardControllerState {
    case horizontal
    case vertical
}

class CardController: UIViewController {
    
    // MARK: - View vars
    var navigationTitleView: NavigationTitleView!
    var peopleButton: UIButton!
    var nameView: NameView!
    
    // MARK: - Empty State View vars
    var monkeyView: UIImageView!
    var nothingToSeeLabel: UILabel!
    var waitingLabel: UILabel!
    var createPollButton: UIButton!
    
    // MARK: - Nonempty State View vars
    var countLabel: UILabel!
    var zoomOutButton: UIButton!
    var collectionView: UICollectionView!
    var verticalCollectionView: UICollectionView!
    var adapter: ListAdapter!
    
    var pinchRecognizer: UIPinchGestureRecognizer!
    
    // MARK: - Data vars
    var userRole: UserRole!
    var socket: Socket!
    var session: Session!
    var state: CardControllerState!
    var pollsDateArray: [PollsDateModel]!
    var currentIndex: Int!
    
    // MARK: - Constants    
    let monkeyViewLength: CGFloat = 32.0
    let monkeyViewTopPadding: CGFloat = 142.0
    let nothingToSeeLabelWidth: CGFloat = 200.0
    let nothingToSeeLabelTopPadding: CGFloat = 20.0
    let waitingLabelWidth: CGFloat = 220.0
    let waitingLabelTopPadding: CGFloat = 10.0
    let countLabelWidth: CGFloat = 42.0
    let adminNothingToSeeText = "Nothing to see here."
    let userNothingToSeeText = "Nothing to see yet."
    let adminWaitingText = "You haven't asked any polls yet!\nTry it out below."
    let userWaitingText = "Waiting for the host to post a poll."
    
    init(pollsDateArray: [PollsDateModel], session: Session, userRole: UserRole) {
        super.init(nibName: nil, bundle: nil)
        
        self.session = session
        self.userRole = userRole
        self.socket = Socket(id: "\(session.id)", userType: userRole.rawValue)
        self.state = .horizontal
        self.currentIndex = pollsDateArray.isEmpty ? -1 : pollsDateArray.count - 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clickerDeepBlack

        pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(detectedPinchAction))
        view.addGestureRecognizer(pinchRecognizer)
        
        socket.addDelegate(self)
//        setupHorizontalNavBar()
        
        let results = [
            "A": [
                "text": "Moon name #1",
                "count": 3
            ],
            "B": [
                "text": "Moon name #2",
                "count": 2
            ]
        ]
        let poll = Poll(id: 1, text: "What is the name of Saturn's largest moon?", results: results, type: .multipleChoice, isLive: false)
        pollsDateArray = [PollsDateModel(date: "08/29/18", polls: [poll]), PollsDateModel(date: "08/30/18", polls: [poll]), PollsDateModel(date: "08/31/18", polls: [poll])]
        setupVerticalNavBar()
        mockVertical()
        
        if (userRole == .admin && session.name == session.code) {
            setupNameView()
        }
    }
   
    // MARK - NAME THE POLL
    func setupNameView() {
        nameView = NameView(frame: .zero)
        nameView.session = session
        nameView.delegate = self
        view.addSubview(nameView)

        nameView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func setupEmptyState() {
        monkeyView = UIImageView(image: #imageLiteral(resourceName: "monkey_emoji"))
        monkeyView.contentMode = .scaleAspectFit
        view.addSubview(monkeyView)
        
        nothingToSeeLabel = UILabel()
        nothingToSeeLabel.font = ._16SemiboldFont
        nothingToSeeLabel.textColor = .clickerBorder
        nothingToSeeLabel.textAlignment = .center
        nothingToSeeLabel.text = userRole == .admin ? adminNothingToSeeText : userNothingToSeeText
        view.addSubview(nothingToSeeLabel)
        
        waitingLabel = UILabel()
        waitingLabel.font = ._14MediumFont
        waitingLabel.textColor = .clickerMediumGrey
        waitingLabel.textAlignment = .center
        waitingLabel.lineBreakMode = .byWordWrapping
        waitingLabel.numberOfLines = 0
        waitingLabel.text = userRole == .admin ? adminWaitingText : userWaitingText
        view.addSubview(waitingLabel)
        
        monkeyView.snp.makeConstraints { make in
            make.width.height.equalTo(monkeyViewLength)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(monkeyViewTopPadding)
        }
        
        nothingToSeeLabel.snp.makeConstraints { make in
            make.width.equalTo(nothingToSeeLabelWidth)
            make.centerX.equalToSuperview()
            make.top.equalTo(monkeyView.snp.bottom).offset(nothingToSeeLabelTopPadding)
        }
        
        waitingLabel.snp.makeConstraints { make in
            make.width.equalTo(waitingLabelWidth)
            make.centerX.equalToSuperview()
            make.top.equalTo(nothingToSeeLabel.snp.bottom).offset(waitingLabelTopPadding)
        }
    }
    
    func removeEmptyState() {
        monkeyView.removeFromSuperview()
        nothingToSeeLabel.removeFromSuperview()
        waitingLabel.removeFromSuperview()
    }
    
    func setupCards() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let collectionViewInset = view.frame.width * 0.05
        collectionView.contentInset = UIEdgeInsetsMake(0, collectionViewInset, 0, collectionViewInset)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        view.addSubview(collectionView)
        
        let updater = ListAdapterUpdater()
        adapter = ListAdapter(updater: updater, viewController: self)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        zoomOutButton = UIButton()
        zoomOutButton.setImage(#imageLiteral(resourceName: "zoomout"), for: .normal)
        zoomOutButton.addTarget(self, action: #selector(zoomOutBtnPressed), for: .touchUpInside)
        view.addSubview(zoomOutButton)
        
        countLabel = UILabel()
        // TODO: Set count string to be 1 / total num of polls
        let countString = "1/1"
        countLabel.attributedText = getCountLabelAttributedString(countString)
        countLabel.textAlignment = .center
        countLabel.backgroundColor = UIColor.clickerLabelGrey
        countLabel.layer.cornerRadius = 12
        countLabel.clipsToBounds = true
        view.addSubview(countLabel)
        
        zoomOutButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.width.height.equalTo(20)
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalTo(zoomOutButton.snp.centerY)
            make.centerX.equalToSuperview()
            make.width.equalTo(countLabelWidth)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(6)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Vertical Collection View
    // TODO: REMOVE THIS FUNCTION
    func mockVertical() {
        self.state = .vertical
        
        peopleButton = UIButton()
        peopleButton.setImage(#imageLiteral(resourceName: "person"), for: .normal)
        peopleButton.setTitle("0", for: .normal)
        peopleButton.titleLabel?.font = UIFont._16RegularFont
        peopleButton.sizeToFit()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let collectionViewInset = view.frame.width * 0.1
        collectionView.contentInset = UIEdgeInsetsMake(0, collectionViewInset, 0, collectionViewInset)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        
        let updater = ListAdapterUpdater()
        adapter = ListAdapter(updater: updater, viewController: self)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    func setupVertical() {
        zoomOutButton.removeFromSuperview()
        countLabel.removeFromSuperview()
        
        self.state = .vertical
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
        }
        adapter.performUpdates(animated: true, completion: nil)
        
        setupVerticalNavBar()
    }
    
    func setupVerticalNavBar() {
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.titleView = UIView()
        self.navigationItem.rightBarButtonItems = []
    }
    
    func revertToHorizontal() {
        setupCards()
        setupHorizontalNavBar()
    }
    
    // MARK: SCROLLVIEW METHODS
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView != collectionView) {
            return
        }
        // TODO: Add logic for updating countLabel to display current question # / total num questions
    }

    func setupHorizontalNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        // REMOVE BOTTOM SHADOW
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationTitleView = NavigationTitleView()
        navigationTitleView.updateNameAndCode(name: session.name, code: session.code)
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
    
    // MARK: Helpers
    func getCardType(from poll: Poll) -> CardType {
        if (poll.isLive) {
            return .live
        } else if (poll.isShared) {
            return .shared
        } else {
            return .ended
        }
    }
    
    func updateDatePollsArr() {
        GetSortedPolls(id: session.id).make()
            .done { pollsDateArray in
                self.pollsDateArray = pollsDateArray
                DispatchQueue.main.async { self.collectionView.reloadData() }
            }.catch { error in
                print(error)
        }
    }
    
    func appendPoll(poll: Poll) {
        // TODO
    }
    
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
    
    // MARK: ACTIONS
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
    
    @objc func goBack() {
        socket.socket.disconnect()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func zoomOutBtnPressed() {
        setupVertical()
    }
    
    @objc func detectedPinchAction(_ sender: UIPinchGestureRecognizer) {
        let isPinchOut: Bool = (sender.scale > 1)
        if (isPinchOut && verticalCollectionView != nil && !verticalCollectionView.isDescendant(of: self.view)) {
            zoomOutBtnPressed()
        }
    }
    
    // MARK: - View lifecycle
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}