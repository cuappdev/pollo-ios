//
//  SettingsViewController.swift
//  Clicker
//
//  Created by eoin on 9/13/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import IGListKit

class SettingsViewController: UIViewController {

    // MARK: Views and VC's
    var logOutButton: UIButton!
    var collectionView: UICollectionView!
    var adapter: ListAdapter!

    // MARK: Data
    var data: [SettingsDataModel]!
    
    // MARK: Layout constants
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.title = "Settings"
        loadData()
        setupViews()
        setupConstraints()
    }
    
    func loadData() {
        let s1 = SettingsDataModel(state: .info, title: "Account", description: "jes543@cornell.edu")
        let s2 = SettingsDataModel(state: .info, title: "About", description: "Pollo is made by Cornell AppDev, a team which Jack Schluger and Kevin Chan created in 1998.")
        let s3 = SettingsDataModel(state: .link, title: "Account")
        let s4 = SettingsDataModel(state: .link, title: "Account")
        
        data = [s1,s2,s3,s4]
        
        
    }
    
    func setupViews() {
        logOutButton = UIButton()
        logOutButton.setTitle("Log Out", for: .normal)
        logOutButton.titleLabel?.textAlignment = .center
        logOutButton.titleLabel?.font = ._22SemiboldFont
        logOutButton.addTarget(self, action: #selector(logOutAction), for: .touchUpInside)
        view.addSubview(logOutButton)
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .red
        view.addSubview(collectionView)
        
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    func setupConstraints() {
        logOutButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(70)
            make.height.equalTo(22)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width)
            make.bottom.equalTo(logOutButton.snp.top)
        }
    }
    
    // MARK: Actions
    @objc func logOutAction() {
        print("logging out")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SettingsViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return SettingsSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    
}
