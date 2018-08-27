//
//  PollsViewController.swift
//  Clicker
//
//  Created by eoin on 4/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//
import UIKit
import GoogleSignIn
import Presentr

class PollsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SliderBarDelegate, EditSessionDelegate {
    
    let popupViewHeight: CGFloat = 140
    let editModalHeight: Float = 205
    
    var pollsOptionsView: OptionsView!
    var pollsCollectionView: UICollectionView!
    let pollsIdentifier = "pollsCellID"
    var titleLabel: UILabel!
    var newPollButton: UIButton!
    var bottomBarView: UIView!
    var joinSessionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerNavBarLightGrey
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: - SCROLLVIEW
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pollsOptionsView.sliderBarLeftConstraint.constant = scrollView.contentOffset.x / 2
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        pollsOptionsView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
    
    // MARK: - SLIDERBAR DELEGATE
    func scrollToIndex(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        pollsCollectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        titleLabel = UILabel()
        titleLabel.text = "Polls"
        titleLabel.font = ._30SemiboldFont
        titleLabel.textColor = .clickerDeepBlack
        view.addSubview(titleLabel)
        
        pollsOptionsView = OptionsView(frame: .zero, options: ["Created", "Joined"], sliderBarDelegate: self)
        pollsOptionsView.setBackgroundColor(color: .clickerNavBarLightGrey)
        view.addSubview(pollsOptionsView)
        
        let layout = UICollectionViewFlowLayout()
        pollsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        pollsCollectionView.alwaysBounceHorizontal = true
        pollsCollectionView.delegate = self
        pollsCollectionView.dataSource = self
        pollsCollectionView.register(PollsCell.self, forCellWithReuseIdentifier: pollsIdentifier)
        pollsCollectionView.showsVerticalScrollIndicator = false
        pollsCollectionView.showsHorizontalScrollIndicator = false
        pollsCollectionView.backgroundColor = .clickerBackground
        pollsCollectionView.isPagingEnabled = true
        view.addSubview(pollsCollectionView)
        
        newPollButton = UIButton()
        newPollButton.setImage(#imageLiteral(resourceName: "create_poll"), for: .normal)
        newPollButton.addTarget(self, action: #selector(newPollAction), for: .touchUpInside)
        view.addSubview(newPollButton)
        
        bottomBarView = UIView()
        bottomBarView.backgroundColor = .clickerDeepBlack
        view.addSubview(bottomBarView)
        
        joinSessionButton = UIButton()
        joinSessionButton.backgroundColor = .clear
        joinSessionButton.addTarget(self, action: #selector(showJoinSessionPopup), for: .touchUpInside)
        joinSessionButton.setImage(UIImage(named: "JoinTabBarIcon"), for: .normal)
        view.addSubview(joinSessionButton)
        
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(90)
            make.centerX.equalToSuperview()
            make.height.equalTo(35.5)
        }
        
        
        pollsOptionsView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        bottomBarView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(54)
        }
        
        pollsCollectionView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomBarView.snp.top)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(pollsOptionsView.snp.bottom)
        }
        
        newPollButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.width.equalTo(19)
            make.height.equalTo(19)
            make.right.equalToSuperview().offset(-15)
        }
        
        joinSessionButton.snp.makeConstraints { make in
            make.centerX.equalTo(bottomBarView.snp.centerX)
            make.width.equalTo(bottomBarView.snp.height)
            make.height.equalTo(bottomBarView.snp.height)
            make.centerY.equalTo(bottomBarView.snp.centerY)
        }
    }
    
    // MARK - actions
    @objc func newPollAction() {
        GenerateCode().make()
            .done { code in
                StartSession(code: code, name: code, isGroup: false).make()
                    .done { session in
                        let socket = Socket(id: "\(session.id)", userType: "admin")
                        let cardVC = CardController()
                        cardVC.socket = socket
                        cardVC.code = code
                        cardVC.name = code
                        cardVC.sessionId = session.id
                        cardVC.userRole = .admin
                        self.navigationController?.pushViewController(cardVC, animated: true)
                        self.navigationController?.setNavigationBarHidden(false, animated: true)
                    }.catch { error in
                        print("error: ", error)
                }
            }.catch { error in
                print(error)
        }
    }
    
    // MARK: EDIT SESSION DELEGATE
    func editSession(forSession session: Session) {
        let width = ModalSize.full
        let height = ModalSize.custom(size: editModalHeight)
        let originY = view.frame.height - CGFloat(editModalHeight)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: originY))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        let presenter = Presentr(presentationType: customType)
        presenter.backgroundOpacity = 0.6
        presenter.dismissOnSwipe = true
        presenter.dismissOnSwipeDirection = .bottom
        let editPollVC = EditPollViewController()
        editPollVC.session = session
        editPollVC.homeViewController = self
        let navigationVC = UINavigationController(rootViewController: editPollVC)
        customPresentViewController(presenter, viewController: navigationVC, animated: true, completion: nil)
    }
    
    // JOIN SESSION
    @objc func showJoinSessionPopup() {
        let width = ModalSize.full
        let height = ModalSize.custom(size: Float(popupViewHeight))
        let originY = view.frame.height - popupViewHeight
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: originY))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let presenter: Presentr = Presentr(presentationType: customType)
        presenter.backgroundOpacity = 0.6
        presenter.roundCorners = false
        presenter.dismissOnSwipe = true
        presenter.dismissOnSwipeDirection = .bottom
        
        let joinSessionVC = JoinViewController()
        joinSessionVC.dismissController = self
        joinSessionVC.popupHeight = popupViewHeight
        customPresentViewController(presenter, viewController: joinSessionVC, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.parent is UINavigationController {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
        if let cell0 = pollsCollectionView?.cellForItem(at: IndexPath(row: 0, section: 0)) as! PollsCell? {
            cell0.getPollSessions()
            cell0.pollsTableView.reloadData()
        } else {
            print("first time loading row 0")
        }
        
        if let cell1 = pollsCollectionView?.cellForItem(at: IndexPath(row: 1, section: 0)) as! PollsCell? {
            cell1.getPollSessions()
            cell1.pollsTableView.reloadData()
        } else {
            print("first time loading row 1")
        }
        
    }
    
    // TODO: Move this function to where it will be used
    @objc func createPoll() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let width = ModalSize.full
        let height = ModalSize.custom(size: Float(view.frame.size.height - statusBarHeight))
        let originY = statusBarHeight
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: originY))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let presenter: Presentr = Presentr(presentationType: customType)
        presenter.backgroundColor = .black
        presenter.roundCorners = true
        presenter.cornerRadius = 15
        presenter.dismissOnSwipe = true
        presenter.dismissOnSwipeDirection = .bottom
        
        let pollBuilderVC = PollBuilderViewController()
        pollBuilderVC.dismissController = self
        customPresentViewController(presenter, viewController: pollBuilderVC, animated: true, completion: nil)
    }
    
}
