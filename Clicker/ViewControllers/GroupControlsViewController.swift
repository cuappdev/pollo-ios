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
    var infoView: GroupControlsInfoView!
    var attendanceLabel: UILabel!
    var collectionView: UICollectionView!
    var exportButton: UIButton!

    // MARK: - Data vars
    var adapter: ListAdapter!
    var session: Session!
    var pollsDateAttendanceArray: [PollsDateAttendanceModel] = []
    var numMembers: Int = 0
    var isExportable: Bool = false {
        didSet {
            if exportButton != nil {
                updateExportButton(for: isExportable)
            }
        }
    }

    // MARK: - Constants
    let separatorLineViewWidth: CGFloat = 0.5
    let attendanceLabelTopPadding: CGFloat = 38
    let attendanceLabelHorizontalPadding: CGFloat = 16.5
    let infoViewHeight: CGFloat = 20
    let infoViewTopPadding: CGFloat = 28
    let infoViewHorizontalPadding: CGFloat = 30
    let collectionViewTopPadding: CGFloat = 16
    let collectionViewBottomPadding: CGFloat = 24
    let collectionViewHeight: CGFloat = 218
    let exportButtonWidthScaleFactor: CGFloat = 0.43
    let exportButtonHeight: CGFloat = 47
    let exportButtonBorderWidth: CGFloat = 1
    let exportButtonTopPadding: CGFloat = 12
    let navigtionTitle = "Group Controls"
    let backImageName = "back"
    let attendanceLabelText = "Attendance"
    let exportButtonTitle = "Export"

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    init(session: Session, pollsDateAttendanceArray: [PollsDateAttendanceModel], numMembers: Int) {
        super.init(nibName: nil, bundle: nil)
        self.session = session
        self.pollsDateAttendanceArray = pollsDateAttendanceArray
        self.numMembers = numMembers
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerBlack1

        setupNavBar()
        setupViews()
        setupConstraints()
    }

    private func setupNavBar() {
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

    private func setupViews() {
        infoView = GroupControlsInfoView()
        let numPolls = pollsDateAttendanceArray.reduce(0) { (result, pollsDateAttendanceModel) -> Int in
            return result + pollsDateAttendanceModel.model.polls.count
        }
        infoView.configure(numMembers: numMembers, numPolls: numPolls, code: session.code)
        view.addSubview(infoView)

        attendanceLabel = UILabel()
        attendanceLabel.text = attendanceLabelText
        attendanceLabel.font = ._21SemiboldFont
        attendanceLabel.textAlignment = .center
        attendanceLabel.textColor = .white
        view.addSubview(attendanceLabel)

        let layout = UICollectionViewFlowLayout()
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
        exportButton.layer.cornerRadius = exportButtonHeight / 2.0
        exportButton.layer.borderWidth = exportButtonBorderWidth
        view.addSubview(exportButton)
        view.bringSubview(toFront: exportButton)

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
        infoView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(infoViewTopPadding)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(infoViewHeight)
        }

        attendanceLabel.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(attendanceLabelTopPadding)
            make.leading.equalToSuperview().offset(attendanceLabelHorizontalPadding)
            make.trailing.equalToSuperview().inset(attendanceLabelHorizontalPadding)
        }

        collectionView.snp.makeConstraints { make in
            make.leading.equalTo(attendanceLabel)
            make.trailing.equalTo(attendanceLabel)
            make.top.equalTo(attendanceLabel.snp.bottom).offset(collectionViewTopPadding)
            make.height.equalTo(collectionViewHeight)
        }

        exportButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(exportButtonWidthScaleFactor)
            make.height.equalTo(exportButtonHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom).offset(exportButtonTopPadding)
        }
    }

    private func updateExportButton(for isExportable: Bool) {
        let titleColor: UIColor = isExportable ? .white : .clickerGrey2
        let backgroundColor: UIColor = isExportable ? .clickerGreen0 : .clear
        let borderColor: UIColor = isExportable ? .clickerGreen0 : UIColor.white.withAlphaComponent(0.9)
        exportButton.setTitleColor(titleColor, for: .normal)
        exportButton.backgroundColor = backgroundColor
        exportButton.layer.borderColor = borderColor.cgColor
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
        if pollsDateAttendanceArray.count <= 3 {
            return pollsDateAttendanceArray
        }
        let viewAllModel = ViewAllModel()
        return [pollsDateAttendanceArray[0], pollsDateAttendanceArray[1], pollsDateAttendanceArray[2], viewAllModel]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is PollsDateAttendanceModel {
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

extension GroupControlsViewController: AttendanceViewControllerDelegate {

    func attendanceViewControllerWillDisappear(with pollsDateAttendanceArray: [PollsDateAttendanceModel]) {
        let deselectedPollsDateAttendanceArray = pollsDateAttendanceArray.map { PollsDateAttendanceModel(model: $0.model, isSelected: false) }
        self.pollsDateAttendanceArray = deselectedPollsDateAttendanceArray
        adapter.performUpdates(animated: false, completion: nil)
        isExportable = false
    }

}
