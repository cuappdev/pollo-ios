//
//  PollsDateViewController.swift
//  Pollo
//
//  Created by Kevin Chan on 9/23/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import FutureNova
import IGListKit
import Presentr
import UIKit
import NotificationBannerSwift

protocol PollsDateViewControllerDelegate: class {
    func pollsDateViewControllerWasPopped(for userRole: UserRole)
}

class PollsDateViewController: UIViewController {
    
    // MARK: - View vars
    var adapter: ListAdapter!
    var collectionView: UICollectionView!
    var collectionViewLayout: UICollectionViewFlowLayout!
    var createPollButton: UIButton!
    var exportNoticeLabel: UILabel!
    var exportNoticeView: UIView!
    var navigationTitleView: NavigationTitleView!
    var peopleButton: UIButton!
    
    // MARK: - Data vars
    private let networking: Networking = URLSession.shared.request
    var numberOfPeople: Int = 0
    var pollsDateArray: [PollsDateModel]!
    var session: Session!
    var socket: Socket!
    var userRole: UserRole!
    weak var delegate: PollsDateViewControllerDelegate?
    
    // MARK: - Constants
    let collectionViewTopPadding: CGFloat = 20
    let countLabelWidth: CGFloat = 42.0
    let exportNoticeLabelHeight: CGFloat = 34
    let exportNoticeLabelTopPadding: CGFloat = 9
    let exportNoticeLabelWidth: CGFloat = 299
    let exportNoticeViewBorderWidth: CGFloat = 1.5
    let exportNoticeViewBottomPadding: CGFloat = 77
    let exportNoticeViewCornerRadius: CGFloat = 6
    let exportNoticeViewHeight: CGFloat = 51
    let exportNoticeViewWidth: CGFloat = 343
    let insetPadding: CGFloat = 16
    
    init(delegate: PollsDateViewControllerDelegate, pollsDateArray: [PollsDateModel], session: Session, userRole: UserRole) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.pollsDateArray = pollsDateArray
        self.session = session
        self.userRole = userRole
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkestGrey
        setupViews()
        setupNavBar()
        setupConstraints()
        self.socket = Socket(id: "\(session.id)", delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if createPollButton != nil {
            let livePollExists = session.isLive ?? false
            createPollButton.isUserInteractionEnabled = !livePollExists
            createPollButton.isHidden = livePollExists
        }
        if !pollsDateArray.isEmpty {
            removeEmptyModels()
        }
        socket.updateDelegate(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Layout
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
            createPollButton.isHidden = pollsDateArray.last?.polls.last?.state == .live
            createPollButton.setImage(#imageLiteral(resourceName: "whiteCreatePoll"), for: .normal)
            createPollButton.addTarget(self, action: #selector(createPollBtnPressed), for: .touchUpInside)
            let createPollBarButton = UIBarButtonItem(customView: createPollButton)
            self.navigationItem.rightBarButtonItems = [createPollBarButton]
        }
    }
    
    func setupViews() {
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollIndicatorInsets = .zero
        collectionView.bounces = true
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        view.sendSubviewToBack(collectionView)
        
        if userRole == .admin {
            let attributedString = NSMutableAttributedString(string: "Visit pollo.cornellappdev.com/export on a desktop device to export participation data.", attributes: [
              .font: UIFont.systemFont(ofSize: 14.0, weight: .medium),
              .foregroundColor: UIColor.white
            ])
            attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 5, length: 1))
            attributedString.addAttribute(.foregroundColor, value: UIColor.polloGreen, range: NSRange(location: 6, length: 31))
            exportNoticeLabel = UILabel()
            exportNoticeLabel.font = ._14MediumFont
            exportNoticeLabel.textAlignment = .center
            exportNoticeLabel.attributedText = attributedString
            exportNoticeLabel.numberOfLines = 0
            view.addSubview(exportNoticeLabel)
            
            exportNoticeView = UIView()
            exportNoticeView.layer.cornerRadius = exportNoticeViewCornerRadius
            exportNoticeView.layer.borderWidth = exportNoticeViewBorderWidth
            exportNoticeView.layer.borderColor = UIColor.white.cgColor
            view.addSubview(exportNoticeView)
        }
        
        let updater = ListAdapterUpdater()
        adapter = ListAdapter(updater: updater, viewController: self)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        BannerController.shared.show(NotificationBanner.connectingBanner())
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(collectionViewTopPadding)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        if userRole == .admin {
            exportNoticeView.snp.makeConstraints { make in
                make.bottom.equalTo(view.snp.bottom).inset(exportNoticeViewBottomPadding)
                make.height.equalTo(exportNoticeViewHeight)
                make.width.equalTo(exportNoticeViewWidth)
                make.centerX.equalToSuperview()
            }
            
            exportNoticeLabel.snp.makeConstraints { make in
                make.top.equalTo(exportNoticeView.snp.top).offset(exportNoticeLabelTopPadding)
                make.height.equalTo(exportNoticeLabelHeight)
                make.width.equalTo(exportNoticeLabelWidth)
                make.centerX.equalTo(exportNoticeView.snp.centerX)
            }
        }
    }

    // MARK: ACTIONS
    @objc func createPollBtnPressed() {
        let pollBuilderViewController = PollBuilderViewController(delegate: self)
        pollBuilderViewController.modalPresentationStyle = .custom
        pollBuilderViewController.transitioningDelegate = self
        present(pollBuilderViewController, animated: true, completion: nil)
    }

    func deleteSession(with id: String) -> Future<DeleteResponse> {
        return networking(Endpoint.deleteSession(with: id)).decode()
    }
    
    @objc func goBack() {
        socket.updateDelegate(nil)
        socket.socket.disconnect()
        BannerController.shared.dismiss()
        self.navigationController?.popViewController(animated: true)
        if pollsDateArray.isEmpty && session.name == session.code {
            deleteSession(with: session.id).observe { [weak self] result in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .value(let response):
                        if response.success {
                            self.delegate?.pollsDateViewControllerWasPopped(for: self.userRole)
                        } else {
                            let alertController = self.createAlert(title: "Error", message: "Failed to delete session. Try again!")
                            self.present(alertController, animated: true, completion: nil)
                        }
                    case .error(let error):
                        print(error)
                        let alertController = self.createAlert(title: "Error", message: "Failed to delete session. Try again!")
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        } else {
            self.delegate?.pollsDateViewControllerWasPopped(for: self.userRole)
        }
    }
    
    func getMembers(with id: String) -> Future<Response<[GetMemberResponse]>> {
        return networking(Endpoint.getMembers(with: id)).decode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
