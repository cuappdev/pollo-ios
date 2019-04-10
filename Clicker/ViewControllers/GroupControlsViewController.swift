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
import CoreLocation

class GroupControlsViewController: UIViewController {

    // MARK: - View vars
    var navigationTitleView: NavigationTitleView!
    var collectionView: UICollectionView!

    // MARK: - Data vars
    private let networking: Networking = URLSession.shared.request
    var adapter: ListAdapter!
    var session: Session!
    var pollsDateAttendanceArray: [PollsDateAttendanceModel] = []
    var exportAttendanceModel = ExportAttendanceModel(isExportable: false)
    var numMembers = 0
    var infoModel: GroupControlsInfoModel!
    var attendanceHeader: HeaderModel!
    var pollSettingsHeader: HeaderModel!
    var liveQuestionsSetting: PollsSettingModel!
    var filterSetting: PollsSettingModel!
    var locationSetting: PollsSettingModel!
    var isExportable: Bool = false {
        didSet {
            exportAttendanceModel = ExportAttendanceModel(isExportable: isExportable)
            adapter.performUpdates(animated: false, completion: nil)
        }
    }
    var spaceOne: SpaceModel!
    var spaceTwo: SpaceModel!
    var spaceThree: SpaceModel!

    // MARK: - Constants
    let attendanceHeaderLabel = "Attendance"
    let attendanceLabelHorizontalPadding: CGFloat = 16.5
    let attendanceLabelTopPadding: CGFloat = 38
    let backImageName = "back"
    let collectionViewBottomPadding: CGFloat = 24
    let collectionViewHeight: CGFloat = 218
    let collectionViewTopPadding: CGFloat = 10
    let filterDescription = "Filter responses to prohibit inappropriate language"
    let filterTitle = "Filter Responses"
    let infoViewHeight: CGFloat = 20
    let infoViewHorizontalPadding: CGFloat = 30
    let infoViewTopPadding: CGFloat = 28
    let liveQuestionsDescription = "Allow audience to ask questions to host during session"
    let liveQuestionsTitle = "Live Questions"
    let locationDescription = "Only allow poll members within 300 feet to participate"
    let locationTitle = "Location Restriction"
    let navigationTitle = "Group Controls"
    let pollSettingsHeaderLabel = "Poll Settings"
    let separatorLineViewWidth: CGFloat = 0.5
    let spaceOneHeight: CGFloat = 38
    let spaceTwoHeight: CGFloat = 16
    let spaceThreeHeight: CGFloat = 57
    
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

        spaceOne = SpaceModel(space: spaceOneHeight, backgroundColor: .clickerBlack1)
        spaceTwo = SpaceModel(space: spaceTwoHeight, backgroundColor: .clickerBlack1)
        spaceThree = SpaceModel(space: spaceThreeHeight, backgroundColor: .clickerBlack1)

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
        navigationTitleView.configure(primaryText: navigationTitle, secondaryText: session.name)
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
    
    func updateSession(id: Int, name: String, code: String, isLocationRestricted: Bool) -> Future<Response<Session>> {
        return networking(Endpoint.updateSession(id: id, name: name, code: code, isLocationRestricted: isLocationRestricted)).decode()
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
        let numPolls = pollsDateAttendanceArray.reduce(0) { (result, pollsDateAttendanceModel) -> Int in
            return result + pollsDateAttendanceModel.model.polls.count
        }
        
        infoModel = GroupControlsInfoModel(numMembers: numMembers, numPolls: numPolls, code: session.code)
        
        attendanceHeader = HeaderModel(title: attendanceHeaderLabel)
        pollSettingsHeader = HeaderModel(title: pollSettingsHeaderLabel)
        
        liveQuestionsSetting = PollsSettingModel(title: liveQuestionsTitle, description: liveQuestionsDescription, type: .liveQuestions, isEnabled: true)
        filterSetting = PollsSettingModel(title: filterTitle, description: filterDescription, type: .filter, isEnabled: true)
        locationSetting = PollsSettingModel(title: locationTitle, description: locationDescription, type: .location, isEnabled: session.isLocationRestricted)
        
        if pollsDateAttendanceArray.count <= 3 {
            let precursorArray: [ListDiffable] = [infoModel, spaceOne, attendanceHeader, spaceTwo]
            let postArray: [ListDiffable] = [exportAttendanceModel, spaceThree, pollSettingsHeader, liveQuestionsSetting, filterSetting, locationSetting, spaceTwo]
            return [precursorArray, pollsDateAttendanceArray, postArray].flatMap {$0}
        }
        let viewAllModel = ViewAllModel()
        return [infoModel, spaceOne, attendanceHeader, spaceTwo, pollsDateAttendanceArray[0], pollsDateAttendanceArray[1], pollsDateAttendanceArray[2], spaceTwo, viewAllModel, exportAttendanceModel, spaceThree, pollSettingsHeader, liveQuestionsSetting, filterSetting, locationSetting, spaceTwo]
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
            let settingsModel = object as! PollsSettingModel
            return PollSettingsSectionController(settingsModel: settingsModel, delegate: self)
        } else {
            return ViewAllSectionController(delegate: self)
        }
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }

}

extension GroupControlsViewController: PollSettingsSectionControllerDelegate {
    
    func pollSettingsSectionControllerDidToggleSetting(settingsModel: PollsSettingModel) {
        switch settingsModel.type {
        case .filter:
            break
        case .liveQuestions:
            break
        case .location:
            if !isLocationEnabled() && !session.isLocationRestricted {
                adapter.performUpdates(animated: false, completion: nil)
                let alertController = createAlert(title: "Location Not Enabled", message: "Please enable location services in Settings if you want to use this feature.")
                present(alertController, animated: true, completion: nil)
                return
            }
            updateSession(id: session.id, name: session.name, code: session.code, isLocationRestricted: !session.isLocationRestricted).observe { [weak self] result in
                switch result {
                case .value:
                    self?.session.isLocationRestricted.toggle()
                case.error(let error):
                    print(error)
                    let alertController = self?.createAlert(title: "Error", message: "Failed to update location settings. Try again!")
                    if let alertController = alertController {
                        self?.present(alertController, animated: true, completion: nil)
                    }
                }
                self?.adapter.performUpdates(animated: false, completion: nil)
            }
        }
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
