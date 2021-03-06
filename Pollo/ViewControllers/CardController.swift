//
//  CardController.swift
//  Pollo
//
//  Created by eoin on 4/15/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit
import FutureNova
import Presentr
import UIKit
import NotificationBannerSwift
import Reachability

protocol CardControllerDelegate: class {

    func cardControllerDidStartNewPoll(poll: Poll)
    func cardControllerWillDisappear(with pollsDateModel: PollsDateModel, numberOfPeople: Int)
    func navigationTitleViewNavigationButtonTapped()
    func pollDeleted(_ pollID: String, userRole: UserRole)
    func pollDeletedLive()
    func pollEnded(_ poll: Poll, userRole: UserRole)
    func pollStarted(_ poll: Poll, userRole: UserRole)
    func receivedResults(_ poll: Poll)
    func updatedTally(_ poll: Poll)
    
}

class CardController: UIViewController {
    
    // MARK: - View vars
    var adapter: ListAdapter!
    var collectionView: UICollectionView!
    var collectionViewLayout: UICollectionViewFlowLayout!
    var countLabel: UILabel!
    var countLabelBackgroundView: UIView!
    var createPollButton: UIButton!
    var navigationTitleView: NavigationTitleView!
    var peopleButton: UIButton!
    
    // MARK: - Data vars
    lazy var cvItemWidth = collectionView.frame.width - 2*collectionViewHorizontalInset
    private let networking: Networking = URLSession.shared.request
    var currentIndex: Int! = 0
    var isInitialLoad: Bool = true
    var numberOfPeople: Int!
    var pollsDateModel: PollsDateModel!
    var session: Session!
    var socket: Socket!
    var startingScrollingOffset: CGPoint!
    var tapGestureRecognizer: UITapGestureRecognizer!
    var userRole: UserRole!
    var wasScrolledToIndex: Int!
    weak var delegate: CardControllerDelegate?
    var reachability: Reachability!
    var isConnected: Bool = true
    
    // MARK: - Constants
    let collectionViewHorizontalInset: CGFloat = 17.0
    let collectionViewTopPadding: CGFloat = 16.0
    let countLabelBackgroundViewTopPadding: CGFloat = 24
    let countLabelHeight: CGFloat = 21.0
    let countLabelHorizontalPadding: CGFloat = 5
    let countLabelWidth: CGFloat = 30.5
    let editModalHeight: CGFloat = 205
    let swipeVelocityThreshold: CGFloat = 0.5
    
    init(delegate: CardControllerDelegate, pollsDateModel: PollsDateModel, session: Session, socket: Socket, userRole: UserRole, numberOfPeople: Int) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.numberOfPeople = numberOfPeople
        self.pollsDateModel = pollsDateModel
        self.session = session
        self.socket = socket
        self.userRole = userRole
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkestGrey
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        setupNavBar()
        setupViews()
        socket.updateDelegate(self)
        do {
            try reachability = Reachability()
        } catch {
            fatalError("Reachability failed on init.")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        socket.updateDelegate(self)
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Could not start reachability notifier")
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }

    @objc func reachabilityChanged(note: Notification) {
        guard let reachability = note.object as? Reachability else { return }
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
            socket.socket.connect()
        case .cellular:
            print("Reachable via Cellular")
            socket.socket.connect()
        default:
            print("Network not reachable")
            self.socket.manager.reconnect()
        }
    }
    
    @objc func didTap() {
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        if isInitialLoad && pollsDateModel.polls.last?.state == .live {
            scrollToLatestPoll()
        }
        isInitialLoad = false
    }
    
    // MARK: - Layout
    func setupViews() {
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = collectionViewHorizontalInset
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: collectionViewHorizontalInset, bottom: 0, right: collectionViewHorizontalInset)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = true
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        view.sendSubviewToBack(collectionView)
        
        let updater = ListAdapterUpdater()
        adapter = ListAdapter(updater: updater, viewController: self)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        
        countLabelBackgroundView = UIView()
        countLabelBackgroundView.backgroundColor = .darkGrey
        countLabelBackgroundView.clipsToBounds = true
        countLabelBackgroundView.layer.cornerRadius = countLabelHeight / 2
        view.addSubview(countLabelBackgroundView)

        countLabel = UILabel()
        countLabel.textAlignment = .center
        countLabel.font = ._12SemiboldFont
        countLabel.adjustsFontSizeToFitWidth = true
        countLabel.textColor = .white
        view.addSubview(countLabel)
        
        updateCountLabelText()
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(countLabelBackgroundView.snp.bottom).offset(collectionViewTopPadding)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        // REMOVE BOTTOM SHADOW
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        let textHeight = navigationController?.navigationBar.frame.height ?? 0
        navigationTitleView = getNavigationTitleView(primaryText: session.name, primaryTextHeight: textHeight, secondaryText: "Code: \(session.code)", secondaryTextHeight: textHeight, userRole: userRole, delegate: self)
        self.navigationItem.titleView = navigationTitleView
        
        let backImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(goBack))
        
        if userRole == .admin {
            createPollButton = UIButton()
            createPollButton.isHidden = session.isLive ?? false
            createPollButton.setImage(#imageLiteral(resourceName: "whiteCreatePoll"), for: .normal)
            createPollButton.addTarget(self, action: #selector(createPollBtnPressed), for: .touchUpInside)
            let createPollBarButton = UIBarButtonItem(customView: createPollButton)
            self.navigationItem.rightBarButtonItems = [createPollBarButton]
        }

    }
    
    // MARK: Helpers
    func updateCountLabelText() {
        let total = pollsDateModel.polls.count
        if total > 0 {
            let countLabelText = "\(currentIndex + 1)/\(total)"
            countLabel.text = countLabelText
            countLabelBackgroundView.isHidden = false
            let countLabelWidth = countLabelText.width(withConstrainedHeight: countLabelHeight, font: countLabel.font)
            countLabelBackgroundView.snp.remakeConstraints { remake in
                remake.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(countLabelBackgroundViewTopPadding)
                remake.centerX.equalToSuperview()
                remake.width.equalTo(countLabelWidth + countLabelHorizontalPadding * 2)
                remake.height.equalTo(countLabelHeight)
            }

            countLabel.snp.remakeConstraints { remake in
                remake.center.equalTo(countLabelBackgroundView)
                remake.width.equalTo(countLabelWidth)
                remake.height.equalTo(countLabelHeight)
            }
        } else {
            countLabel.text = ""
            countLabelBackgroundView.isHidden = true
        }
    }
    
    // MARK: - Actions
    @objc func createPollBtnPressed() {
        let pollBuilderViewController = PollBuilderViewController(delegate: self)
        pollBuilderViewController.modalPresentationStyle = .custom
        pollBuilderViewController.transitioningDelegate = self
        present(pollBuilderViewController, animated: true, completion: nil)
    }
    
    @objc func goBack() {
        delegate?.cardControllerWillDisappear(with: pollsDateModel, numberOfPeople: numberOfPeople)
        self.navigationController?.popViewController(animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
