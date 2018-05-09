//
//  CardController+Extension.swift
//  Clicker
//
//  Created by Kevin Chan on 5/4/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

extension CardController {
    
    func setupVertical() {
        mainCollectionView.removeFromSuperview()
        zoomOutButton.removeFromSuperview()
        countLabel.removeFromSuperview()
                
        setupVerticalNavBar()
        setupVerticalCollectionView()
    }
    
    func setupVerticalCollectionView() {
        let layout = UICollectionViewFlowLayout()
        verticalCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        verticalCollectionView.delegate = self
        verticalCollectionView.dataSource = self
        verticalCollectionView.register(CardDateCell.self, forCellWithReuseIdentifier: dateIdentifier)
        verticalCollectionView.showsVerticalScrollIndicator = false
        verticalCollectionView.showsHorizontalScrollIndicator = false
        verticalCollectionView.alwaysBounceVertical = true
        verticalCollectionView.backgroundColor = .clear
        verticalCollectionView.isPagingEnabled = true
        view.addSubview(verticalCollectionView)
        view.sendSubview(toBack: verticalCollectionView)
        
        verticalCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupVerticalNavBar() {
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.titleView = UIView()
        self.navigationItem.rightBarButtonItems = []
    }
    
    func revertToHorizontal() {
        verticalCollectionView.removeFromSuperview()
        setupCards()
        setupHorizontalNavBar()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == verticalCollectionView) {
            currentDatePollsIndex = indexPath.item
            currentPolls = datePollsArr[currentDatePollsIndex].1
            revertToHorizontal()
        }
    }
    
}
