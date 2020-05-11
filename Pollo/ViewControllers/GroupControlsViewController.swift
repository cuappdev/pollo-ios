//
//  GroupControlsViewController.swift
//  Pollo
//
//  Created by Kevin Chan on 11/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import FutureNova
import IGListKit
import SnapKit
import UIKit

protocol GroupControlsViewControllerDelegate: class {
    func groupControlsViewControllerDidUpdateSession(_ session: Session)
}

class GroupControlsViewController: UIViewController {

    // MARK: - View vars
    var navigationTitleView: NavigationTitleView!
    var collectionView: UICollectionView!

    // MARK: - Data vars
    var adapter: ListAdapter!
    var session: Session!
    var pollsDateAttendanceArray: [PollsDateAttendanceModel] = []
    var exportAttendanceModel = ExportAttendanceModel(isExportable: false)
    var numMembers = 0
    var infoModel: GroupControlsInfoModel!
    var attendanceHeader: HeaderModel!
    var isExportable: Bool = false {
        didSet {
            exportAttendanceModel = ExportAttendanceModel(isExportable: isExportable)
            adapter.performUpdates(animated: false, completion: nil)
        }
    }
    private let networking: Networking = URLSession.shared.request
    var spaceOne: SpaceModel!
    var spaceTwo: SpaceModel!

    weak var delegate: GroupControlsViewControllerDelegate?

    // MARK: - Constants
    let attendanceHeaderLabel = "Attendance"
    let attendanceLabelHorizontalPadding: CGFloat = 16.5
    let attendanceLabelTopPadding: CGFloat = 38
    let backImageName = "back"
    let collectionViewBottomPadding: CGFloat = 24
    let collectionViewHeight: CGFloat = 218
    let collectionViewTopPadding: CGFloat = 10
    let infoViewHeight: CGFloat = 20
    let infoViewHorizontalPadding: CGFloat = 30
    let infoViewTopPadding: CGFloat = 28
    let navigationTitle = "Group Controls"
    let separatorLineViewWidth: CGFloat = 0.5
    let spaceOneHeight: CGFloat = 38
    let spaceThreeHeight: CGFloat = 16
    let spaceTwoHeight: CGFloat = 16

    init(session: Session, pollsDateAttendanceArray: [PollsDateAttendanceModel], numMembers: Int, delegate: GroupControlsViewControllerDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.session = session
        self.pollsDateAttendanceArray = pollsDateAttendanceArray
        self.numMembers = numMembers
        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkestGrey

        spaceOne = SpaceModel(space: spaceOneHeight, backgroundColor: .darkestGrey)
        spaceTwo = SpaceModel(space: spaceTwoHeight, backgroundColor: .darkestGrey)

        attendanceHeader = HeaderModel(title: attendanceHeaderLabel)

        let numPolls = pollsDateAttendanceArray.reduce(0) { (result, pollsDateAttendanceModel) -> Int in
            return result + pollsDateAttendanceModel.model.polls.count
        }
        infoModel = GroupControlsInfoModel(numMembers: numMembers, numPolls: numPolls, code: session.code)

        setupNavBar()
        setupViews()
        setupConstraints()
    }

    private func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        // REMOVE BOTTOM SHADOW
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        let textHeight = navigationController?.navigationBar.frame.height ?? 0
        navigationTitleView = getNavigationTitleView(primaryText: navigationTitle, primaryTextHeight: textHeight, secondaryText: session.name, secondaryTextHeight: textHeight, userRole: nil, delegate: nil)
        self.navigationItem.titleView = navigationTitleView

        let backImage = UIImage(named: backImageName)?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(goBack))
    }

    private func setupViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = true
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = true
        view.addSubview(collectionView)

        let updater = ListAdapterUpdater()
        adapter = ListAdapter(updater: updater, viewController: self)
        adapter.collectionView = collectionView
        adapter.dataSource = self

        // isExportable if any of the first 3 are selected
        switch pollsDateAttendanceArray.count {
        case 0:
            isExportable = false
        case 1:
            isExportable = pollsDateAttendanceArray[0].isSelected
        case 2:
            isExportable = pollsDateAttendanceArray[0].isSelected || pollsDateAttendanceArray[1].isSelected
        default:
            isExportable = pollsDateAttendanceArray[0].isSelected || pollsDateAttendanceArray[1].isSelected || pollsDateAttendanceArray[2].isSelected
        }
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(collectionViewTopPadding)
        }

    }

    // MARK: - Action
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

extension GroupControlsViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        if pollsDateAttendanceArray.count <= 3 {
            let precursorArray: [ListDiffable] = [infoModel, spaceOne, attendanceHeader, spaceTwo]
            let postArray: [ListDiffable] = [exportAttendanceModel]
            return [precursorArray, pollsDateAttendanceArray, postArray].flatMap {$0}
        }
        let viewAllModel = ViewAllModel()
        return [infoModel, spaceOne, attendanceHeader, spaceTwo, pollsDateAttendanceArray[0], pollsDateAttendanceArray[1], pollsDateAttendanceArray[2], viewAllModel, exportAttendanceModel]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is PollsDateAttendanceModel {
            return PollsDateAttendanceSectionController(delegate: self)
        } else if object is ExportAttendanceModel {
            return ExportAttendanceSectionController(delegate: self)
        } else if object is GroupControlsInfoModel {
            return GroupControlsInfoSectionController()
        } else if object is SpaceModel {
            return SpaceSectionController(noResponses: false)
        } else if object is HeaderModel {
            return HeaderSectionController()
        } else if object is PollsSettingModel {
            return PollSettingsSectionController(delegate: self)
        } else {
            return ViewAllSectionController(delegate: self)
        }
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }

}

extension GroupControlsViewController: PollsDateAttendanceSectionControllerDelegate {

    func pollsDateAttendanceSectionControllerDidTap(for pollsDateAttendanceModel: PollsDateAttendanceModel) {
        isExportable = pollsDateAttendanceArray.contains(where: { $0.isSelected })
    }
    
}

extension GroupControlsViewController: ViewAllSectionControllerDelegate {

    func viewAllSectionControllerWasTapped() {
        let attendanceVC = AttendanceViewController(delegate: self, pollsDateAttendanceArray: pollsDateAttendanceArray)
        self.navigationController?.pushViewController(attendanceVC, animated: true)
    }

}

extension GroupControlsViewController: ExportAttendanceSectionControllerDelegate {

    func exportAttendanceSectionControllerButtonWasTapped() {

    }

}

extension GroupControlsViewController: AttendanceViewControllerDelegate {

    func attendanceViewControllerWillDisappear(with pollsDateAttendanceArray: [PollsDateAttendanceModel]) {
        let deselectedPollsDateAttendanceArray = pollsDateAttendanceArray.map { PollsDateAttendanceModel(model: $0.model, isSelected: false) }
        self.pollsDateAttendanceArray = deselectedPollsDateAttendanceArray
        adapter.performUpdates(animated: false, completion: nil)
        isExportable = false
    }

}

// MARK: - PollSettingsSectionControllerDelegate
extension GroupControlsViewController: PollSettingsSectionControllerDelegate {

    func pollSettingsSectionControllerDidUpdate(_ sectionController: PollSettingsSectionController, to newValue: Bool) {
        // Send future group setting changes here
    }

}
