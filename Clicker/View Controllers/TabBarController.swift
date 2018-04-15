//
//  TabBarController.swift
//  Clicker
//
//  Created by eoin on 4/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//
import UIKit

class TabBarController: UITabBarController {
    
    var pollsViewController: PollsViewController!
    var joinViewController: JoinViewController!
    var groupViewController: GroupsViewController!
    
    var pollsNavigationController: UINavigationController!
    var groupNavigationController: UINavigationController!
    

    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().barTintColor = .clickerDeepBlack
        
//<<<<<<< HEAD
        setupViewControllers()
        setupNavagationControllers()
        let viewControllerList: [UIViewController] = [pollsNavigationController, joinViewController, groupNavigationController]
        viewControllers = viewControllerList
    }
    
    func setupViewControllers() {
        pollsViewController = PollsViewController()
        let selectedPollsImage = UIImage(named: "polls_selected")?.withRenderingMode(.alwaysOriginal)
        let pollsTabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "polls"), selectedImage: selectedPollsImage)
        pollsTabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
        pollsViewController.tabBarItem = pollsTabBarItem
        
        joinViewController = JoinViewController()
        let joinImage = UIImage(named: "join")?.withRenderingMode(.alwaysOriginal)
        let joinTabBarItem = UITabBarItem(title: "", image: joinImage, tag: 1)
        joinTabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
        joinViewController.tabBarItem = joinTabBarItem
        
        groupViewController = GroupsViewController()
        let selectedGroupImage = UIImage(named: "groups_selected")?.withRenderingMode(.alwaysOriginal)
        let groupsTabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "groups"), selectedImage: selectedGroupImage)
        groupsTabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
        groupViewController.tabBarItem = groupsTabBarItem

    }
    
    func setupNavagationControllers() {
        pollsNavigationController = UINavigationController(rootViewController: pollsViewController)
        pollsViewController.hidesBottomBarWhenPushed = true
        pollsNavigationController.setNavigationBarHidden(true, animated: false)

        groupNavigationController = UINavigationController(rootViewController: groupViewController)
        groupViewController.hidesBottomBarWhenPushed = true
        groupNavigationController.setNavigationBarHidden(true, animated: false)
    }

}
