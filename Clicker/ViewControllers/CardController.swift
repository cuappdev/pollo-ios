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
    var zoomOutButton: UIButton!
    var mainCollectionView: UICollectionView!
    var verticalCollectionView: UICollectionView!
    var countLabel: UILabel!
    
    var pinchRecognizer: UIPinchGestureRecognizer!
    
    // MARK: - Data vars
    var userRole: UserRole!
    var socket: Socket!
    var session: Session!
    var datePollsArr: [(String, [Poll])] = []
    var currentPolls: [Poll] = []
    var currentDatePollsIndex: Int!
    
    // MARK: - Constants
    let askedIdentifer = "askedCardID"
    let answerIdentifier = "answerCardID"
    let dateIdentifier = "dateCardID"
    
    init(session: Session, userRole: UserRole) {
        super.init(nibName: nil, bundle: nil)
        
        self.session = session
        self.userRole = userRole
        self.socket = Socket(id: "\(session.id)", userType: userRole.rawValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clickerDeepBlack

        pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(detectedPinchAction))
        view.addGestureRecognizer(pinchRecognizer)
        
        socket.addDelegate(self)
        setupNavBar()
        if (datePollsArr.count == 0) {
            setupEmpty()
        } else {
            currentDatePollsIndex = datePollsArr.count - 1
            currentPolls = datePollsArr[currentDatePollsIndex].1
            setupCards()
        }
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
            nothingToSeeLabel.text = "Nothing to see here."
            waitingLabel.text = "You haven't asked any polls yet!\nTry it out below."
        } else {
            nothingToSeeLabel.text = "Nothing to see yet."
            waitingLabel.text = "Waiting for the host to post a poll."
        }
        
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
    
    func removeEmptyState() {
        monkeyView.removeFromSuperview()
        nothingToSeeLabel.removeFromSuperview()
        waitingLabel.removeFromSuperview()
    }
    
    func setupCards() {
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
        setupNavBar()
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
        
    func setupNavBar() {
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
            .done { datePollsArr in
                self.datePollsArr = datePollsArr
                self.currentPolls = datePollsArr[self.currentDatePollsIndex].1
                DispatchQueue.main.async { self.mainCollectionView.reloadData() }
            }.catch { error in
                print(error)
        }
    }
    
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
