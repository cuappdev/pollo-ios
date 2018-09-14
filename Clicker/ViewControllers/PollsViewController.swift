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
    var newPollButton: UIButton!
    var bottomBarView: UIView!
    var joinSessionButton: UIButton!
    var settingsButton: UIButton!
    
    // MARK: - Data vars
    var pollTypeModels: [PollTypeModel]!
    
    // MARK: - Constants
    let popupViewHeight: CGFloat = 140
    let editModalHeight: Float = 205
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerGrey8
        
        let createdPollTypeModel = PollTypeModel(pollType: .created)
        let joinedPollTypeModel = PollTypeModel(pollType: .joined)
        pollTypeModels = [createdPollTypeModel, joinedPollTypeModel]
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        titleLabel = UILabel()
        titleLabel.text = "Polls"
        titleLabel.font = ._30SemiboldFont
        titleLabel.textColor = .clickerBlack1
        view.addSubview(titleLabel)
        
        pollsOptionsView = OptionsView(frame: .zero, options: ["Created", "Joined"], sliderBarDelegate: self)
        pollsOptionsView.setBackgroundColor(color: .clickerGrey8)
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
        
        newPollButton = UIButton()
        newPollButton.setImage(#imageLiteral(resourceName: "create_poll"), for: .normal)
        newPollButton.addTarget(self, action: #selector(newPollAction), for: .touchUpInside)
        view.addSubview(newPollButton)
        
        bottomBarView = UIView()
        bottomBarView.backgroundColor = .clickerBlack1
        view.addSubview(bottomBarView)
        
        joinSessionButton = UIButton()
        joinSessionButton.backgroundColor = .clear
        joinSessionButton.addTarget(self, action: #selector(showJoinSessionPopup), for: .touchUpInside)
        joinSessionButton.setImage(UIImage(named: "JoinTabBarIcon"), for: .normal)
        view.addSubview(joinSessionButton)
        
        settingsButton = UIButton()
        settingsButton.setImage(#imageLiteral(resourceName: "JoinTabBarIcon"), for: .normal)
        settingsButton.addTarget(self, action: #selector(settingsAction), for: .touchUpInside)
        view.addSubview(settingsButton)
        
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
            make.right.equalToSuperview().inset(15)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.centerY.equalTo(newPollButton.snp.centerY)
            make.left.equalToSuperview().offset(15)
        }
        
        joinSessionButton.snp.makeConstraints { make in
            make.centerX.equalTo(bottomBarView.snp.centerX)
            make.width.equalTo(bottomBarView.snp.height)
            make.height.equalTo(bottomBarView.snp.height)
            make.centerY.equalTo(bottomBarView.snp.centerY)
        }
    }
    
    // MARK - Actions
    @objc func newPollAction() {
        GenerateCode().make()
            .done { code in
                StartSession(code: code, name: code, isGroup: false).make()
                    .done { session in
                        let cardVC = CardController(pollsDateArray: [], session: session, userRole: .admin)
                        self.navigationController?.pushViewController(cardVC, animated: true)
                        self.navigationController?.setNavigationBarHidden(false, animated: true)
                    }.catch { error in
                        print("error: ", error)
                }
            }.catch { error in
                print(error)
        }
    }
    
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
    
    @objc func settingsAction() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - View lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.parent is UINavigationController {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
}
