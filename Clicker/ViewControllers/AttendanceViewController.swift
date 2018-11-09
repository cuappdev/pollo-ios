//
//  AttendanceViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 11/8/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import IGListKit

class AttendanceViewController: UIViewController {

    // MARK: - View vars
    var navigationTitleView: NavigationTitleView!
    var collectionView: UICollectionView!
    var exportButton: UIButton!

    // MARK: - Data vars
    var adapter: ListAdapter!
    var session: Session!
    var pollsDateAttendanceArray: [PollsDateAttendanceModel] = []

    // MARK: - Constants
    let collectionViewTopPadding: CGFloat = 30.5
    let collectionViewHorizontalPadding: CGFloat = 18
    let exportButtonWidthScaleFactor: CGFloat = 0.43
    let exportButtonHeight: CGFloat = 47
    let exportButtonBorderWidth: CGFloat = 1
    let exportButtonBottomPadding: CGFloat = 35.5
    let navigtionTitle = "Attendance"
    let backImageName = "back"
    let attendanceLabelText = "Attendance"
    let exportButtonTitle = "Export"
    let selectAllBarButtonTitle = "Select All"

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    init(pollsDateAttendanceArray: [PollsDateAttendanceModel]) {
        super.init(nibName: nil, bundle: nil)
        self.pollsDateAttendanceArray = pollsDateAttendanceArray
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerBlack1
        self.title = navigtionTitle
        setupNavBar()
        setupViews()
        setupConstraints()
    }

    func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        // REMOVE BOTTOM SHADOW
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        let backImage = UIImage(named: backImageName)?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(goBack))

        let selectAllBarButtonItem = UIBarButtonItem(title: selectAllBarButtonTitle, style: .plain, target: self, action: #selector(selectAllBtnPressed))
        selectAllBarButtonItem.tintColor = .clickerGreen0
        self.navigationItem.rightBarButtonItem = selectAllBarButtonItem
    }

    func setupViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = true
        collectionView.alwaysBounceVertical = true
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
        collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(collectionViewHorizontalPadding)
            make.trailing.equalToSuperview().inset(collectionViewHorizontalPadding)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(collectionViewTopPadding)
            make.bottom.equalToSuperview()
        }

        exportButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(exportButtonWidthScaleFactor)
            make.height.equalTo(exportButtonHeight)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(exportButtonBottomPadding)
        }
    }

    // MARK: - Action
    @objc func selectAllBtnPressed() {
        let selectedPollsDateAttendanceArray = pollsDateAttendanceArray.map { (model) -> PollsDateAttendanceModel in
            return PollsDateAttendanceModel(model: model.model, isSelected: true)
        }
        pollsDateAttendanceArray = selectedPollsDateAttendanceArray
        adapter.performUpdates(animated: false, completion: nil)
    }

    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AttendanceViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return pollsDateAttendanceArray
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return PollsDateAttendanceSectionController(delegate: self)
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }

}

extension AttendanceViewController: PollsDateAttendanceSectionControllerDelegate {

    func pollsDateAttendanceSectionControllerDidTap(for pollsDateAttendanceModel: PollsDateAttendanceModel) {
        // TODO
    }

}
