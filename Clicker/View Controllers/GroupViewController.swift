//
//  GroupViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 3/28/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    
    var groupOptionsView: OptionsView!
    var groupCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Groups"
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        groupOptionsView = OptionsView(frame: .zero, options: ["Multiple Choice", "Free Response"], sliderBarDelegate: self)
        view.addSubview(groupOptionsView)
        
        let layout = UICollectionViewFlowLayout()
        groupCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        groupCollectionView.alwaysBounceHorizontal = true
        groupCollectionView.delegate = self
        groupCollectionView.dataSource = self
        groupCollectionView.showsVerticalScrollIndicator = false
        groupCollectionView.showsHorizontalScrollIndicator = false
        groupCollectionView.register(MCSectionCell.self, forCellWithReuseIdentifier: "mcSectionCell")
        groupCollectionView.register(FRSectionCell.self, forCellWithReuseIdentifier: "frSectionCellID")
        groupCollectionView.backgroundColor = .clickerBackground
        groupCollectionView.isPagingEnabled = true
        view.addSubview(groupCollectionView)
    }
    
    func setupConstraints() {
        
    }
    
}
