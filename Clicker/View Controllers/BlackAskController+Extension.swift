//
//  BlackAskController+Extension.swift
//  Clicker
//
//  Created by Kevin Chan on 5/4/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

extension BlackAskController {
    
    func setupVertical() {
        setupVerticalNavBar()
        setupVerticalCollectionView()
    }
    
    func setupVerticalCollectionView() {
        let layout = UICollectionViewFlowLayout()
        verticalCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        verticalCollectionView.delegate = self
        verticalCollectionView.dataSource = self
        verticalCollectionView.register(CardRowCell.self, forCellWithReuseIdentifier: cardRowCellIdentifier)
        verticalCollectionView.showsVerticalScrollIndicator = false
        verticalCollectionView.showsHorizontalScrollIndicator = false
        verticalCollectionView.alwaysBounceVertical = true
        verticalCollectionView.backgroundColor = .clear
        verticalCollectionView.isPagingEnabled = true
        view.addSubview(verticalCollectionView)
        
        verticalCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupVerticalNavBar() {
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.titleView = UIView()
        self.navigationItem.rightBarButtonItems = []
    }
    
}
