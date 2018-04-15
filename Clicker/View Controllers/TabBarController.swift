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
        
        setupViewControllers()
        setupNavagationControllers()
        let viewControllerList: [UIViewController] = [pollsNavigationController, joinViewController, groupNavigationController]
        viewControllers = viewControllerList
    }
    
    func setupViewControllers() {
        pollsViewController = PollsViewController()
        pollsViewController.tabBarItem = UITabBarItem(title: "Polls", image: nil, tag: 0)
        
        joinViewController = JoinViewController()
        joinViewController.tabBarItem = UITabBarItem(title: "Join", image: nil, tag: 1)
        
        groupViewController = GroupsViewController()
        groupViewController.tabBarItem = UITabBarItem(title: "Groups", image: nil, tag: 2)
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
