//
//  DateCell.swift
//  Clicker
//
//  Created by eoin on 4/15/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class DateCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 18
        layout.scrollDirection = .horizontal
        //collectionView.alwaysBounceHorizontal = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LiveQAskedCard.self, forCellWithReuseIdentifier: "liveQAskedCardID")
        collectionView.register(ClosedQAskedCard.self, forCellWithReuseIdentifier: "closedQAskedCardID")
        collectionView.register(ClosedQAskedSharedCard.self, forCellWithReuseIdentifier: "closedQAskedSharedCardID")
        collectionView.register(LiveQAnswerCard.self, forCellWithReuseIdentifier: "liveQAnswerCardID")
        collectionView.register(ClosedQAnsweredCard.self, forCellWithReuseIdentifier: "closedQAnsweredCardID")
        collectionView.register(ClosedQAnsweredSharedCard.self, forCellWithReuseIdentifier: "closedQAnsweredSharedCardID")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        addSubview(collectionView)
    }
    
    func setupConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(35)
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(11)
            make.width.equalToSuperview()
            make.height.equalTo(444)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - COLLECTIONVIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        switch indexPath.row {
        case 0:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "liveQAnswerCardID", for: indexPath) as! LiveQAnswerCard
        case 1:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "closedQAnsweredCardID", for: indexPath) as! ClosedQAnsweredCard
        case 2:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "closedQAnsweredSharedCardID", for: indexPath) as! ClosedQAnsweredSharedCard
        case 3:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "liveQAskedCardID", for: indexPath) as! LiveQAskedCard
        case 4:
             cell = collectionView.dequeueReusableCell(withReuseIdentifier: "closedQAskedCardID", for: indexPath) as! ClosedQAskedCard
        default:
           cell = collectionView.dequeueReusableCell(withReuseIdentifier: "closedQAskedSharedCardID", for: indexPath) as! ClosedQAskedSharedCard
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 339, height: 415)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
