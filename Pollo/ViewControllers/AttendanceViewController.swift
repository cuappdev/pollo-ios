//
//  AttendanceViewController.swift
//  Pollo
//
//  Created by Kevin Chan on 11/8/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit
import UIKit

protocol AttendanceViewControllerDelegate: class {
    func attendanceViewControllerWillDisappear(with pollsDateAttendanceArray: [PollsDateAttendanceModel])
}

class AttendanceViewController: UIViewController {

    // MARK: - View vars
    var collectionView: UICollectionView!
    var exportButton: UIButton!
    var navigationTitleView: NavigationTitleView!
    var selectAllBarButtonItem: UIBarButtonItem!

    // MARK: - Data vars
    var adapter: ListAdapter!
    var isSelectAll: Bool = false
    var pollsDateAttendanceArray: [PollsDateAttendanceModel] = []
    var session: Session!
    weak var delegate: AttendanceViewControllerDelegate?

    var isExportable: Bool = false {
        didSet {
            if exportButton != nil {
                updateExportButton(for: isExportable)
            }
        }
    }

    // MARK: - Constants
    let attendanceLabelText = "Attendance"
    let backImageName = "back"
    let cancelBarButtonTitle = "Cancel"
    let collectionViewTopPadding: CGFloat = 30.5
    let exportButtonBorderWidth: CGFloat = 1
    let exportButtonBottomPadding: CGFloat = 35.5
    let exportButtonHeight: CGFloat = 47
    let exportButtonTitle = "Export"
    let exportButtonWidthScaleFactor: CGFloat = 0.43
    let navigtionTitle = "Attendance"
    let selectAllBarButtonTitle = "Select All"

    init(delegate: AttendanceViewControllerDelegate, pollsDateAttendanceArray: [PollsDateAttendanceModel]) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.pollsDateAttendanceArray = pollsDateAttendanceArray
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkestGrey
        self.title = navigtionTitle
        setupNavBar()
        setupViews()
        setupConstraints()
    }

    override func viewWillDisappear(_ animated: Bool) {
        delegate?.attendanceViewControllerWillDisappear(with: pollsDateAttendanceArray)
    }

    private func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barStyle = .black
        // REMOVE BOTTOM SHADOW
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        let backImage = UIImage(named: backImageName)?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(goBack))

        selectAllBarButtonItem = UIBarButtonItem(title: selectAllBarButtonTitle, style: .plain, target: self, action: #selector(selectAllBtnPressed))
        selectAllBarButtonItem.tintColor = .polloGreen
        self.navigationItem.rightBarButtonItem = selectAllBarButtonItem
    }

    private func setupViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
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
        exportButton.layer.cornerRadius = exportButtonHeight / 2.0
        exportButton.layer.borderWidth = exportButtonBorderWidth
        view.addSubview(exportButton)
        view.bringSubviewToFront(exportButton)

        isExportable = pollsDateAttendanceArray.contains(where: { $0.isSelected })
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
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

    private func updateExportButton(for isExportable: Bool) {
        let titleColor: UIColor = isExportable ? .white : .blueGrey
        let backgroundColor: UIColor = isExportable ? .polloGreen : .clear
        let borderColor: UIColor = isExportable ? .polloGreen : UIColor.white.withAlphaComponent(0.9)
        exportButton.setTitleColor(titleColor, for: .normal)
        exportButton.backgroundColor = backgroundColor
        exportButton.layer.borderColor = borderColor.cgColor
    }

    // MARK: - Action
    @objc func selectAllBtnPressed() {
        if !isSelectAll {
            let selectedPollsDateAttendanceArray = pollsDateAttendanceArray.map { PollsDateAttendanceModel(model: $0.model, isSelected: true) }
            pollsDateAttendanceArray = selectedPollsDateAttendanceArray
            adapter.performUpdates(animated: false, completion: nil)
            selectAllBarButtonItem.title = cancelBarButtonTitle
        } else {
            let selectedPollsDateAttendanceArray = pollsDateAttendanceArray.map { PollsDateAttendanceModel(model: $0.model, isSelected: false) }
            pollsDateAttendanceArray = selectedPollsDateAttendanceArray
            adapter.performUpdates(animated: false, completion: nil)
            selectAllBarButtonItem.title = selectAllBarButtonTitle
        }
        isSelectAll.toggle()
        isExportable = isSelectAll
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
        isExportable = pollsDateAttendanceArray.contains(where: { $0.isSelected })
    }

}
