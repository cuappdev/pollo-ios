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
    var exportButton: UIButton!

    // MARK: - Data vars
    var adapter: ListAdapter!
    var session: Session!
    var pollsDateModelArray: [PollsDateModel] = []

    // MARK: - Constants
    let attendanceLabelTopPadding: CGFloat = 38
    let attendanceLabelHorizontalPadding: CGFloat = 16.5
    let collectionViewLineSpacing: CGFloat = 14
    let collectionViewTopPadding: CGFloat = 16
    let collectionViewBottomPadding: CGFloat = 24
    let exportButtonWidthScaleFactor: CGFloat = 0.43
    let exportButtonHeight: CGFloat = 47
    let exportButtonBorderWidth: CGFloat = 1
    let exportButtonBottomPadding: CGFloat = 192.5
    let navigtionTitle = "Group Controls"
    let backImageName = "back"
    let attendanceLabelText = "Attendance"
    let exportButtonTitle = "Export"

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
        collectionView.bounces = false
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = true
        view.addSubview(collectionView)

        let updater = ListAdapterUpdater()
        adapter = ListAdapter(updater: updater, viewController: self)
        adapter.collectionView = collectionView
        adapter.dataSource = self

        exportButton = UIButton()
        exportButton.setTitle(exportButtonTitle, for: .normal)
        exportButton.setTitleColor(.clickerGrey10, for: .normal)
        exportButton.layer.cornerRadius = exportButtonHeight / 2.0
        exportButton.layer.borderColor = UIColor.white.withAlphaComponent(0.9).cgColor
        exportButton.layer.borderWidth = exportButtonBorderWidth
        view.addSubview(exportButton)
        view.bringSubview(toFront: exportButton)
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
            make.bottom.equalTo(exportButton.snp.top).inset(collectionViewBottomPadding)
        }

        exportButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(exportButtonWidthScaleFactor)
            make.height.equalTo(exportButtonHeight)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(exportButtonBottomPadding)
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
        if pollsDateModelArray.count <= 3 {
            return pollsDateModelArray
        }
        let viewAllModel = ViewAllModel()
        return [pollsDateModelArray[0], pollsDateModelArray[1], pollsDateModelArray[2], viewAllModel]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is PollsDateModel {
            return PollsDateAttendanceSectionController(delegate: self)
        } else {
            return ViewAllSectionController(delegate: self)
        }
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }

}

extension GroupControlsViewController: PollsDateAttendanceSectionControllerDelegate {

    func pollsDateAttendanceSectionControllerDidTap(for pollsDateModel: PollsDateModel) {
        // TODO
    }

}

extension GroupControlsViewController: ViewAllSectionControllerDelegate {

    func viewAllSectionControllerWasTapped() {
        // TODO
    }

}
