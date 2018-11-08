//
//  GroupControlsViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 11/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class GroupControlsViewController: UIViewController {

    // MARK: - Constants
    let navigtionTitle = "Group Controls"
    let backImageName = "back"

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = navigtionTitle
        view.backgroundColor = .clickerBlack1

        setupNavBar()
    }

    func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        // REMOVE BOTTOM SHADOW
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        let backImage = UIImage(named: backImageName)?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(goBack))
    }

    // MARK: - Action
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

}
