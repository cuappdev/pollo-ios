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

protocol CardControllerDelegate {
    
    func cardControllerWillDisappear(with pollsDateModel: PollsDateModel)
    func cardControllerDidStartNewPoll(poll: Poll)
    
}

class CardController: UIViewController {
    
    // MARK: - View vars
    var navigationTitleView: NavigationTitleView!
    var peopleButton: UIButton!
    var createPollButton: UIButton!
    var countLabel: UILabel!
    var collectionViewLayout: UICollectionViewFlowLayout!
    var collectionView: UICollectionView!
    var adapter: ListAdapter!
    
    // MARK: - Data vars
    var delegate: CardControllerDelegate!
    var userRole: UserRole!
    var socket: Socket!
    var session: Session!
    var pollsDateModel: PollsDateModel!
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
    
    init(delegate: CardControllerDelegate, pollsDateModel: PollsDateModel, session: Session, userRole: UserRole) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.session = session
        self.userRole = userRole
        self.pollsDateModel = pollsDateModel
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clickerBlack1
        setupNavBar()
        setupViews()
        self.socket = Socket(id: "\(session.id)", userRole: userRole, delegate: self)
    }
    
    // MARK: - Layout
    func setupViews() {
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        let collectionViewXInset = view.frame.width * 0.05
        collectionView.contentInset = UIEdgeInsetsMake(0, collectionViewXInset, 0, collectionViewXInset)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollIndicatorInsets = .zero
        collectionView.bounces = true
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        view.sendSubview(toBack: collectionView)
        
        let updater = ListAdapterUpdater()
        adapter = ListAdapter(updater: updater, viewController: self)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        
        countLabel = UILabel()
        countLabel.textAlignment = .center
        countLabel.backgroundColor = UIColor.clickerGrey10
        countLabel.layer.cornerRadius = 12
        countLabel.clipsToBounds = true
        updateCountLabelText(with: 0)
        view.addSubview(countLabel)
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(countLabelWidth)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(horizontalCollectionViewTopPadding)
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
    
    // MARK: Helpers
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
        let total = pollsDateModel.polls.count
        countLabel.attributedText = getCountLabelAttributedString("\(index + 1)/\(total)")
    }
    
    // MARK: - Actions
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
        
        let pollBuilderNavigationController = UINavigationController(rootViewController: pollBuilderVC)
        pollBuilderNavigationController.isNavigationBarHidden = true
        present(pollBuilderNavigationController, animated: true, completion: nil)
    }
    
    @objc func goBack() {
        delegate.cardControllerWillDisappear(with: pollsDateModel)
        self.navigationController?.popViewController(animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
