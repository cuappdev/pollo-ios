//
//  TabBarController.swift
//  Clicker
//
//  Created by Keivan Shahida on 9/24/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 0)
        
        let viewControllerList = [ homeViewController ]
        viewControllers = viewControllerList
        viewControllers = viewControllerList.map { UINavigationController(rootViewController: $0) }
    }
}
