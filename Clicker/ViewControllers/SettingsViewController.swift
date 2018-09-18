//
//  SettingsViewController.swift
//  Clicker
//
//  Created by eoin on 9/13/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import IGListKit
import GoogleSignIn

class SettingsViewController: UIViewController {

    // MARK: Views and VC's
    var logOutButton: UIButton!
    var collectionView: UICollectionView!
    var lineView: UIView!
    var adapter: ListAdapter!

    // MARK: Data
    var data: [SettingsDataModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        setupNavBar()
        setupViews()
        setupConstraints()
    }
    
    func loadData() {
        let settingsModel1 = SettingsDataModel(state: .info, title: "Account", description:
            User.currentUser?.email)
        let settingsModel2 = SettingsDataModel(state: .info, title: "About", description:
            "Pollo is made by Cornell AppDev, an engineering project team at Cornell University.")
        let settingsModel3 = SettingsDataModel(state: .link, title: "More Apps", description:
            Links.allApps)
        let settingsModel4 = SettingsDataModel(state: .link, title: "Visit Our Website",description:
            Links.appDevSite)
        
        data = [settingsModel1,settingsModel2,settingsModel3,settingsModel4]
    }
    
    func setupNavBar() {
        let gradientLayer = CAGradientLayer()

        var bounds = navigationController?.navigationBar.bounds ?? CGRect()
        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.clickerGrey7.cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        navigationController?.navigationBar.setBackgroundImage(image(fromLayer: gradientLayer), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let backImage = UIImage(named: "exit")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(goBack))
        navigationItem.title = "Settings"
    
    }
    
    func setupViews() {
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        lineView = UIView()
        lineView.backgroundColor = UIColor.clickerGrey5
        view.addSubview(lineView)
        
        logOutButton = UIButton()
        logOutButton.setTitle("Log Out", for: .normal)
        logOutButton.titleLabel?.textAlignment = .center
        logOutButton.titleLabel?.font = UIFont._18MediumFont
        logOutButton.setTitleColor(.black, for: .normal)
        logOutButton.addTarget(self, action: #selector(logOutAction), for: .touchUpInside)
        view.addSubview(logOutButton)
    }
    
    func setupConstraints() {
        logOutButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(22)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(61)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom)
        }
    }
    
    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
    
    // MARK: Actions
    @objc func logOutAction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("cannot log out without AppDelegate!")
            return
        }
        appDelegate.logout()
    }
    
    @objc func goBack() {
         self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
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
