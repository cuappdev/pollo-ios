//
//  TabBarController.swift
//  Clicker
//
//  Created by eoin on 4/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//
import UIKit
import Presentr
import SnapKit

class TabBarController: UITabBarController {
    
    let popupViewHeight: CGFloat = 140
    
    var pollsViewController: PollsViewController!
    var dummyViewController: UIViewController!
    var groupViewController: GroupsViewController!
    var joinSessionButton: UIButton!
    
    var pollsNavigationController: UINavigationController!
    var dummyNavigationController: UINavigationController!
    var groupNavigationController: UINavigationController!
    
    var tabBarHeight: CGFloat!

    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n\n!!!tab bar did load!!!\n\n")
        UITabBar.appearance().barTintColor = .clickerDeepBlack
        
        tabBarHeight = tabBar.frame.size.height
        
        setupViewControllers()
        setupNavigationControllers()
        
        let viewControllerList: [UIViewController] = [pollsNavigationController, dummyNavigationController, groupNavigationController]
        viewControllers = viewControllerList
        
        setUpJoinSessionButton()
    }
    
    func setupViewControllers() {
        pollsViewController = PollsViewController()
        let selectedPollsImage = UIImage(named: "polls_selected")?.withRenderingMode(.alwaysOriginal)
        let pollsTabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "polls"), selectedImage: selectedPollsImage)
        pollsTabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
        pollsViewController.tabBarItem = pollsTabBarItem
        
        dummyViewController = UIViewController()
        let joinImage = UIImage(named: "JoinTabBarIcon")?.withRenderingMode(.alwaysOriginal)
        let joinTabBarItem = UITabBarItem(title: "", image: joinImage, tag: 1)
        joinTabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
        dummyViewController.tabBarItem = joinTabBarItem

        groupViewController = GroupsViewController()
        let selectedGroupImage = UIImage(named: "groups_selected")?.withRenderingMode(.alwaysOriginal)
        let groupsTabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "groups"), selectedImage: selectedGroupImage)
        groupsTabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
        groupViewController.tabBarItem = groupsTabBarItem
    }
    
    func setupNavigationControllers() {
        pollsNavigationController = UINavigationController(rootViewController: pollsViewController)
        pollsNavigationController.setNavigationBarHidden(true, animated: false)
        pollsNavigationController.navigationBar.barTintColor = .clickerDeepBlack
        pollsNavigationController.navigationBar.isTranslucent = false
        
        dummyNavigationController = UINavigationController(rootViewController: dummyViewController)
        dummyNavigationController.setNavigationBarHidden(true, animated: false)
        dummyNavigationController.navigationBar.barTintColor = .clickerDeepBlack
        dummyNavigationController.navigationBar.isTranslucent = false

        groupNavigationController = UINavigationController(rootViewController: groupViewController)
        groupNavigationController.setNavigationBarHidden(true, animated: false)
        groupNavigationController.navigationBar.barTintColor = .clickerDeepBlack
        groupNavigationController.navigationBar.isTranslucent = false
    }
    
    func setUpJoinSessionButton() {
        joinSessionButton = UIButton()
        joinSessionButton.backgroundColor = .clear
        joinSessionButton.addTarget(self, action: #selector(showJoinSessionPopup), for: .touchUpInside)
        view.addSubview(joinSessionButton)
        
        joinSessionButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalToSuperview()
            make.width.equalTo(tabBarHeight)
            make.height.equalTo(tabBarHeight)
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
    
}
