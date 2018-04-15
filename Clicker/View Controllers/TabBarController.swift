//
//  TabBarController.swift
//  Clicker
//
//  Created by eoin on 4/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//
import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().barTintColor = .clickerDeepBlack
        
        let pollsViewController = PollsViewController()
        pollsViewController.tabBarItem = UITabBarItem(title: "Polls", image: nil, tag: 0)
        
        let joinViewController = JoinViewController()
        joinViewController.tabBarItem = UITabBarItem(title: "Join", image: nil, tag: 1)
        
        let groupViewController = GroupsViewController()
        groupViewController.tabBarItem = UITabBarItem(title: "Groups", image: nil, tag: 2)
        
        
        let viewControllerList = [pollsViewController, joinViewController, groupViewController]
        viewControllers = viewControllerList
    }
}
