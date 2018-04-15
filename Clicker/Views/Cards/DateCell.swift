//
//  DateCell.swift
//  Clicker
//
//  Created by eoin on 4/15/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class DateCell: UICollectionViewCell, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var collectionView: UICollectionView!
    var dateLabel: UILabel!
    var cards: [UIViewController]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        setupViews()
        setupConstraints()
    }
    
    
    func setupViews() {
        dateLabel = UILabel()
        dateLabel.text = "TODAY"
        dateLabel.font = ._16SemiboldFont
        dateLabel.textColor = .clickerMediumGray
        addSubview(dateLabel)
        
        /*let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        pollsCollectionView = UICollectionView
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        pollsCollectionView.alwaysBounceHorizontal = true
        pollsCollectionView.delegate = self
        pollsCollectionView.dataSource = self
        pollsCollectionView.register(CreatedCell.self, forCellWithReuseIdentifier: "createdCellID")
        pollsCollectionView.register(JoinedCell.self, forCellWithReuseIdentifier: "joinedCellID")
        pollsCollectionView.showsVerticalScrollIndicator = false
        pollsCollectionView.showsHorizontalScrollIndicator = false
        pollsCollectionView.backgroundColor = .clickerBackground
        pollsCollectionView.isPagingEnabled = true
        view.addSubview(pollsCollectionView)*/
    }
    
    func setupConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(35)
            make.centerX.equalToSuperview()
        }
        
        /*pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(11)
            make.width.equalToSuperview()
            make.height.equalTo(444)
            make.centerX.equalToSuperview()
        }*/
    }
    
    // MARK - page data source
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return cards[0]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return cards[0]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
     return 3
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
