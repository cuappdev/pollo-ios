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

enum CardControllerState {
    case horizontal
    case vertical
}

class CardController: UIViewController {
    
    // MARK: - View vars
    var navigationTitleView: NavigationTitleView!
    var peopleButton: UIButton!
    var createPollButton: UIButton!
    var countLabel: UILabel!
    var zoomOutButton: UIButton!
    var collectionViewLayout: UICollectionViewFlowLayout!
    var collectionView: UICollectionView!
    var adapter: ListAdapter!
    var topGradientView: UIView!
    var topGradientLayer: CAGradientLayer!
    var bottomGradientView: UIView!
    var bottomGradientLayer: CAGradientLayer!
    
    var pinchRecognizer: UIPinchGestureRecognizer!
    
    // MARK: - Data vars
    var userRole: UserRole!
    var socket: Socket!
    var session: Session!
    var state: CardControllerState!
    var pollsDateArray: [PollsDateModel]!
    var currentIndex: Int!
    var indexOfCellBeforeDragging: Int!
    
    // MARK: - Constants    
    let countLabelWidth: CGFloat = 42.0
    let gradientViewHeight: CGFloat = 50.0
    let horizontalCollectionViewTopPadding: CGFloat = 15
    let verticalCollectionViewBottomInset: CGFloat = 50
    let verticalCollectionViewTopPadding: CGFloat = 20
    let adminNothingToSeeText = "Nothing to see here."
    let userNothingToSeeText = "Nothing to see yet."
    let adminWaitingText = "You haven't asked any polls yet!\nTry it out below."
    let userWaitingText = "Waiting for the host to post a poll."
    
    init(pollsDateArray: [PollsDateModel], session: Session, userRole: UserRole) {
        super.init(nibName: nil, bundle: nil)
        self.session = session
        self.userRole = userRole
        self.pollsDateArray = pollsDateArray
        self.state = .horizontal
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clickerBlack1
        pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(detectedPinchAction))
        view.addGestureRecognizer(pinchRecognizer)
        setupHorizontal()
        self.socket = Socket(id: "\(session.id)", userRole: userRole, delegate: self)
    }
    
    override func viewDidLayoutSubviews() {
        guard let _ = topGradientView, let _ = bottomGradientView else { return }
        if (topGradientView.isDescendant(of: view) && bottomGradientView.isDescendant(of: view)) {
            topGradientLayer.frame = topGradientView.bounds
            bottomGradientLayer.frame = bottomGradientView.bounds
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Layout
    func setupCards() {
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        let collectionViewInset = view.frame.width * 0.05
        collectionView.contentInset = UIEdgeInsetsMake(0, collectionViewInset, 0, collectionViewInset)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollIndicatorInsets = .zero
        collectionView.bounces = true
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        view.sendSubview(toBack: collectionView)
        
        currentIndex = pollsDateArray.isEmpty ? -1 : pollsDateArray.count - 1
        
        let updater = ListAdapterUpdater()
        adapter = ListAdapter(updater: updater, viewController: self)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        
        zoomOutButton = UIButton()
        zoomOutButton.setImage(#imageLiteral(resourceName: "zoomout"), for: .normal)
        zoomOutButton.addTarget(self, action: #selector(zoomOutBtnPressed), for: .touchUpInside)
        zoomOutButton.isUserInteractionEnabled = false
        view.addSubview(zoomOutButton)
        
        countLabel = UILabel()
        countLabel.textAlignment = .center
        countLabel.backgroundColor = UIColor.clickerGrey10
        countLabel.layer.cornerRadius = 12
        countLabel.clipsToBounds = true
        view.addSubview(countLabel)
        
        setupConstraints(for: state)
    }
    
    func setupConstraints(for state: CardControllerState) {
        switch state {
        case .horizontal:
            zoomOutButton.snp.remakeConstraints { make in
                make.right.equalToSuperview().inset(24)
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
                make.width.height.equalTo(20)
            }
            
            countLabel.snp.remakeConstraints { make in
                make.centerY.equalTo(zoomOutButton.snp.centerY)
                make.centerX.equalToSuperview()
                make.width.equalTo(countLabelWidth)
            }
            
            collectionView.snp.remakeConstraints { make in
                make.top.equalTo(countLabel.snp.bottom).offset(horizontalCollectionViewTopPadding)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                make.width.equalToSuperview()
                make.centerX.equalToSuperview()
            }
        case .vertical:
            collectionView.snp.remakeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(verticalCollectionViewTopPadding)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                make.width.equalToSuperview()
                make.centerX.equalToSuperview()
            }
        }
    }
    
    func setupHorizontal() {
        setupCards()
        setupHorizontalNavBar()
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
        
        if userRole == .admin {
            createPollButton = UIButton()
            createPollButton.setImage(#imageLiteral(resourceName: "whiteCreatePoll"), for: .normal)
            createPollButton.addTarget(self, action: #selector(createPollBtnPressed), for: .touchUpInside)
            let createPollBarButton = UIBarButtonItem(customView: createPollButton)
            self.navigationItem.rightBarButtonItems = [createPollBarButton, peopleBarButton]
        } else {
            self.navigationItem.rightBarButtonItems = [peopleBarButton]
        }
    }
    
    func setupGradientViews() {
        topGradientView = UIView()
        topGradientView.backgroundColor = .clear
        topGradientLayer = CAGradientLayer()
        topGradientLayer.colors = [UIColor.clickerGrey0.cgColor, UIColor.clear.cgColor]
        topGradientLayer.locations = [0.0, 1.0]
        topGradientView.layer.addSublayer(topGradientLayer)
        view.addSubview(topGradientView)
        view.bringSubview(toFront: topGradientView)
        
        bottomGradientView = UIView()
        bottomGradientView.backgroundColor = .clear
        bottomGradientLayer = CAGradientLayer()
        bottomGradientLayer.colors = [UIColor.clear.cgColor, UIColor.clickerGrey0.cgColor]
        bottomGradientLayer.locations = [0.0, 1.0]
        bottomGradientView.layer.addSublayer(bottomGradientLayer)
        view.addSubview(bottomGradientView)
        view.bringSubview(toFront: bottomGradientView)
        
        topGradientView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(gradientViewHeight)
        }
        
        bottomGradientView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(gradientViewHeight)
        }
    }
    
    func removeGradientViews() {
        topGradientView.removeFromSuperview()
        bottomGradientView.removeFromSuperview()
    }
    
    // MARK: Helpers
    func switchTo(state: CardControllerState) {
        self.state = state
        switch state {
        case .vertical:
            zoomOutButton.removeFromSuperview()
            countLabel.removeFromSuperview()
            collectionViewLayout.scrollDirection = .vertical
            collectionView.contentInset = .zero
        case .horizontal:
            view.addSubview(zoomOutButton)
            view.addSubview(countLabel)
            collectionViewLayout.scrollDirection = .horizontal
            let collectionViewXInset = view.frame.width * 0.05
            collectionView.contentInset = UIEdgeInsetsMake(0, collectionViewXInset, 0, collectionViewXInset)
        }
        setupConstraints(for: state)
        adapter.performUpdates(animated: false, completion: nil)
    }
    
    func getCountLabelAttributedString(_ countString: String) -> NSMutableAttributedString {
        let slashIndex = countString.index(of: "/")?.encodedOffset
        let attributedString = NSMutableAttributedString(string: countString, attributes: [
            .font: UIFont.systemFont(ofSize: 14.0, weight: .bold),
            .foregroundColor: UIColor.clickerGrey2,
            .kern: 0.0
            ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(white: 1.0, alpha: 0.9), range: NSRange(location: 0, length: slashIndex!))
        return attributedString
    }
    
    func updateCountLabelText(with index: Int) {
        let total = pollsDateArray[currentIndex].polls.count
        countLabel.attributedText = getCountLabelAttributedString("\(index + 1)/\(total)")
        zoomOutButton.isUserInteractionEnabled = total > 0
    }
    
    // MARK: ACTIONS
    @objc func createPollBtnPressed() {
        let pollBuilderVC = PollBuilderViewController(delegate: self)
        let width = Float(view.safeAreaLayoutGuide.layoutFrame.size.width)
        let height = Float(view.safeAreaLayoutGuide.layoutFrame.size.height)
        let center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.midX, y: UIApplication.shared.statusBarFrame.height + view.safeAreaLayoutGuide.layoutFrame.midY)
        let presenter = Presentr(presentationType: .custom(width: .custom(size: width), height: .custom(size: height), center: .custom(centerPoint: center)))
        presenter.backgroundOpacity = 0.6
        presenter.roundCorners = true
        presenter.cornerRadius = 15
        presenter.dismissOnSwipe = true
        presenter.dismissOnSwipeDirection = .bottom
        
        let nc = UINavigationController(rootViewController: pollBuilderVC)
        customPresentViewController(presenter, viewController: nc, animated: true, completion: nil)
    }
    
    @objc func goBack() {
        socket.socket.disconnect()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func zoomOutBtnPressed() {
        switchTo(state: .vertical)
    }
    
    @objc func detectedPinchAction(_ sender: UIPinchGestureRecognizer) {
        let isPinchOut: Bool = (sender.scale > 1)
        if isPinchOut {
            zoomOutBtnPressed()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
