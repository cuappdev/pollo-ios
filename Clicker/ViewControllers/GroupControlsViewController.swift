//
//  GroupControlsViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 11/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class GroupControlsViewController: UIViewController {

    // MARK: - View vars
    var navigationTitleView: NavigationTitleView!

    // MARK: - Data vars
    var session: Session!

    // MARK: - Constants
    let navigtionTitle = "Group Controls"
    let backImageName = "back"

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    init(session: Session) {
        super.init(nibName: nil, bundle: nil)
        self.session = session
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerBlack1

        setupNavBar()
    }

    func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        // REMOVE BOTTOM SHADOW
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()

        navigationTitleView = NavigationTitleView()
        navigationTitleView.configure(primaryText: navigtionTitle, secondaryText: session.name)
        self.navigationItem.titleView = navigationTitleView

        let backImage = UIImage(named: backImageName)?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(goBack))
    }

    // MARK: - Action
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
