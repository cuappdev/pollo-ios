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
    
    func cardControllerWillDisappear(with pollsDateModel: PollsDateModel, numberOfPeople: Int)
    func cardControllerDidStartNewPoll(poll: Poll)
    
}

class CardController: UIViewController {
    
    // MARK: - View vars
    var navigationTitleView: NavigationTitleView!
    var peopleButton: UIButton!
    var createPollButton: UIButton!
    var countLabel: UILabel!
    var countLabelBackgroundView: UIView!
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
    var numberOfPeople: Int!
    var isInitialLoad: Bool = true
    
    // MARK: - Constants
    let navigationTitleHeight: CGFloat = 51.5
    let countLabelWidth: CGFloat = 30.5
    let countLabelHeight: CGFloat = 21.0
    let collectionViewTopPadding: CGFloat = 7
    let countLabelHorizontalPadding: CGFloat = 2.5
    let countLabelBackgroundViewTopPadding: CGFloat = 24
    let collectionViewHorizontalInset: CGFloat = 9.0
    
    init(delegate: CardControllerDelegate, pollsDateModel: PollsDateModel, session: Session, socket: Socket, userRole: UserRole, numberOfPeople: Int) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.pollsDateModel = pollsDateModel
        self.session = session
        self.socket = socket
        self.userRole = userRole
        self.numberOfPeople = numberOfPeople
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clickerBlack1
        setupNavBar()
        setupViews()
        socket.updateDelegate(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if createPollButton != nil {
            let livePollExists = pollsDateModel.polls.last?.state == .live
            createPollButton.isUserInteractionEnabled = !livePollExists
            createPollButton.isHidden = livePollExists
        }
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
        collectionView.contentInset = UIEdgeInsetsMake(0, collectionViewHorizontalInset, 0, collectionViewHorizontalInset)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollIndicatorInsets = .zero
        collectionView.bounces = true
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        view.sendSubview(toBack: collectionView)
        
        let updater = ListAdapterUpdater()
        adapter = ListAdapter(updater: updater, viewController: self)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        
        countLabelBackgroundView = UIView()
        countLabelBackgroundView.backgroundColor = .clickerGrey10
        countLabelBackgroundView.clipsToBounds = true
        countLabelBackgroundView.layer.cornerRadius = countLabelHeight / 2
        view.addSubview(countLabelBackgroundView)

        countLabel = UILabel()
        countLabel.textAlignment = .center
        countLabel.font = ._12MediumFont
        countLabel.adjustsFontSizeToFitWidth = true
        countLabel.textColor = .white
        updateCountLabelText(with: 0)
        view.addSubview(countLabel)
        
        countLabelBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(countLabelBackgroundViewTopPadding)
            make.centerX.equalToSuperview()
            make.width.equalTo(countLabelWidth)
            make.height.equalTo(countLabelHeight)
        }
        
        countLabel.snp.makeConstraints { make in
            make.center.equalTo(countLabelBackgroundView.snp.center)
            make.width.equalTo(countLabelBackgroundView).inset(countLabelHorizontalPadding * 2)
            make.height.equalTo(countLabelHeight)
        }
        
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
        
        navigationTitleView = NavigationTitleView()
        navigationTitleView.updateNameAndCode(name: session.name, code: session.code)
        self.navigationItem.titleView = navigationTitleView
        
        let backImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(goBack))
        
        peopleButton = UIButton()
        peopleButton.setImage(#imageLiteral(resourceName: "person"), for: .normal)
        peopleButton.setTitle("\(numberOfPeople ?? 0)", for: .normal)
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
    func updateCountLabelText(with index: Int) {
        let total = pollsDateModel.polls.count
        countLabel.text = "\(index + 1)/\(total)"
    }
    
    // MARK: - Actions
    @objc func createPollBtnPressed() {
        let pollBuilderViewController = PollBuilderViewController(delegate: self)
        pollBuilderViewController.modalPresentationStyle = .custom
        pollBuilderViewController.transitioningDelegate = self
        present(pollBuilderViewController, animated: true, completion: nil)
    }
    
    @objc func goBack() {
        delegate.cardControllerWillDisappear(with: pollsDateModel, numberOfPeople: numberOfPeople)
        self.navigationController?.popViewController(animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

}
