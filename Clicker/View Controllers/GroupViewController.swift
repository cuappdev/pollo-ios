//
//  GroupViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 3/28/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, SliderBarDelegate {
    
    var groupOptionsView: OptionsView!
    var groupCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Groups"
        view.backgroundColor = .white
        
        setupNavBar()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - COLLECTIONVIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "createdCellID", for: indexPath)
        return cell
    }
    
    
    // MARK: - SLIDERBAR DELEGATE
    func scrollToIndex(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        groupCollectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        groupOptionsView = OptionsView(frame: .zero, options: ["Created", "Joined"], sliderBarDelegate: self)
        groupOptionsView.setBackgroundColor(color: .clickerNavBarGrey)
        view.addSubview(groupOptionsView)
        
        let layout = UICollectionViewFlowLayout()
        groupCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        groupCollectionView.alwaysBounceHorizontal = true
        groupCollectionView.delegate = self
        groupCollectionView.dataSource = self
        groupCollectionView.register(CreatedCell.self, forCellWithReuseIdentifier: "createdCellID")
        groupCollectionView.register(JoinedCell.self, forCellWithReuseIdentifier: "joinedCellID")
        groupCollectionView.showsVerticalScrollIndicator = false
        groupCollectionView.showsHorizontalScrollIndicator = false
        groupCollectionView.backgroundColor = .clickerBackground
        groupCollectionView.isPagingEnabled = true
        view.addSubview(groupCollectionView)
    }
    
    func setupConstraints() {
        groupOptionsView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        groupCollectionView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(groupOptionsView.snp.bottom)
        }
    }
    
    func setupNavBar() {
        UINavigationBar.appearance().barTintColor = .clickerNavBarLightGrey
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
}
