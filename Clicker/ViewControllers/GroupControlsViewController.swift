//
//  GroupControlsViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 11/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import IGListKit
import SnapKit

class GroupControlsViewController: UIViewController {

    // MARK: - View vars
    var navigationTitleView: NavigationTitleView!
    var attendanceLabel: UILabel!
    var collectionView: UICollectionView!

    // MARK: - Data vars
    var adapter: ListAdapter!
    var session: Session!
    var pollsDateModelArray: [PollsDateModel] = []

    // MARK: - Constants
    let navigtionTitle = "Group Controls"
    let backImageName = "back"
    let attendanceLabelText = "Attendance"
    let attendanceLabelTopPadding: CGFloat = 38
    let attendanceLabelHorizontalPadding: CGFloat = 16.5
    let collectionViewLineSpacing: CGFloat = 14
    let collectionViewTopPadding: CGFloat = 16

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    init(session: Session, pollsDateModelArray: [PollsDateModel]) {
        super.init(nibName: nil, bundle: nil)
        self.session = session
        self.pollsDateModelArray = pollsDateModelArray
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerBlack1

        setupNavBar()
        setupViews()
        setupConstraints()
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

    func setupViews() {
        attendanceLabel = UILabel()
        attendanceLabel.text = attendanceLabelText
        attendanceLabel.font = ._21SemiboldFont
        attendanceLabel.textAlignment = .center
        attendanceLabel.textColor = .white
        view.addSubview(attendanceLabel)

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = collectionViewLineSpacing
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = true
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)

        let updater = ListAdapterUpdater()
        adapter = ListAdapter(updater: updater, viewController: self)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }

    func setupConstraints() {
        attendanceLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(attendanceLabelTopPadding)
            make.leading.equalToSuperview().offset(attendanceLabelHorizontalPadding)
            make.trailing.equalToSuperview().inset(attendanceLabelHorizontalPadding)
        }

        collectionView.snp.makeConstraints { make in
            make.leading.equalTo(attendanceLabel)
            make.trailing.equalTo(attendanceLabel)
            make.top.equalTo(attendanceLabel.snp.bottom).offset(collectionViewTopPadding)
            make.bottom.equalToSuperview()
        }
    }

    // MARK: - Action
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension GroupControlsViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return pollsDateModelArray
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return PollsDateAttendanceSectionController(delegate: self)
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }

}

extension GroupControlsViewController: PollsDateAttendanceSectionControllerDelegate {

}
