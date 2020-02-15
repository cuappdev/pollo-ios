//
//  BannerController.swift
//  Pollo
//
//  Created by Jack Thompson on 2/7/20.
//  Copyright © 2020 CornellAppDev. All rights reserved.
//

import Foundation
import FutureNova
import UIKit
import NotificationBannerSwift

protocol PollingViewControllerDelegate: class {
    func pollsDateViewControllerWasPopped(for userRole: UserRole)
}

class PollingViewController: UIViewController {

    // MARK: - View vars
    var createPollButton: UIButton!
    var navigationTitleView: NavigationTitleView!

    var childNavController: UINavigationController!
    var pollsDateViewController: PollsDateViewController!

    var currentBanner: BaseNotificationBanner? {
        didSet {
            oldValue?.dismiss()
            currentBanner?.show(bannerPosition: .bottom, on: self)
        }
    }

    // MARK: - Data vars
    private let networking: Networking = URLSession.shared.request
    var pollsDateArray: [PollsDateModel]!
    var session: Session!
    var socket: Socket!
    var userRole: UserRole!
    weak var delegate: PollingViewControllerDelegate?

    init(delegate: PollingViewControllerDelegate, pollsDateArray: [PollsDateModel], session: Session, userRole: UserRole) {
        super.init(nibName: nil, bundle: nil)

        self.delegate = delegate
        self.pollsDateArray = pollsDateArray
        self.session = session
        self.userRole = userRole
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()

        pollsDateViewController = PollsDateViewController(pollsDateArray: [], session: session, userRole: .admin)
        childNavController = UINavigationController(rootViewController: pollsDateViewController)
        childNavController.setNavigationBarHidden(true, animated: false)
        add(childNavController)
//        add(pollsDateViewController)
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
            createPollButton.isHidden = pollsDateArray.last?.polls.last?.state == .live
            createPollButton.setImage(#imageLiteral(resourceName: "whiteCreatePoll"), for: .normal)
            createPollButton.addTarget(self, action: #selector(createPollBtnPressed), for: .touchUpInside)
            let createPollBarButton = UIBarButtonItem(customView: createPollButton)
            self.navigationItem.rightBarButtonItems = [createPollBarButton]
        }
    }

    // MARK: ACTIONS
    @objc func createPollBtnPressed() {
       // ok
    }

    @objc func goBack() {
        if childNavController.popViewController(animated: true) == nil {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
                    self.navigationController?.popViewController(animated: true)
                    childNavController.remove()

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


        // ok


    }

    func getMembers(with id: String) -> Future<Response<[GetMemberResponse]>> {
        return networking(Endpoint.getMembers(with: id)).decode()
    }

    func deleteSession(with id: String) -> Future<DeleteResponse> {
        return networking(Endpoint.deleteSession(with: id)).decode()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension PollingViewController: NavigationTitleViewDelegate {
    func navigationTitleViewNavigationButtonTapped() {
        guard userRole == .admin else { return }
        let pollsDateAttendanceArray = pollsDateArray.map { PollsDateAttendanceModel(model: $0, isSelected: false) }
        getMembers(with: session?.id ?? "").observe { [weak self] result in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .value(let response):
                    let groupControlsVC = GroupControlsViewController(session: self.session, pollsDateAttendanceArray: pollsDateAttendanceArray, numMembers: response.data.count, delegate: self)
                    self.navigationController?.pushViewController(groupControlsVC, animated: true)
                case .error(let error):
                    print(error)
                    let alertController = self.createAlert(title: "Error", message: "Failed to load data. Try again!")
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

// MARK: - GroupControlsViewControllerDelegate
extension PollingViewController: GroupControlsViewControllerDelegate {
    func groupControlsViewControllerDidUpdateSession(_ session: Session) {
        self.session = session
    }


}

public class BannerController {

    static let shared = BannerController()

    var currentBanner: BaseNotificationBanner?

    func show(_ banner: BaseNotificationBanner) {
        banner.delegate = self
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.currentBanner?.dismiss()
            self.currentBanner = banner
            self.currentBanner?.show(bannerPosition: .bottom)
        }
    }

    func dismiss() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.currentBanner?.dismiss()
            self.currentBanner = nil
        }
    }
}

extension BannerController: NotificationBannerDelegate {
    public func notificationBannerWillAppear(_ banner: BaseNotificationBanner) {
        if self.currentBanner == nil {
            banner.isHidden = true
        }
    }

    public func notificationBannerDidAppear(_ banner: BaseNotificationBanner) {
        if self.currentBanner == nil {
            banner.dismiss()
        }
    }

    public func notificationBannerWillDisappear(_ banner: BaseNotificationBanner) { }

    public func notificationBannerDidDisappear(_ banner: BaseNotificationBanner) { }


}
