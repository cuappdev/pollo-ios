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
    var socket: Socket!
    var polls: [Poll]!
    var liveQuestion: Question! // FOR USERS
    
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
        collectionView.alwaysBounceHorizontal = true
        let inset = (frame.width - CGFloat(frame.width * 0.9)) / 2.0
        collectionView.contentInset = UIEdgeInsetsMake(0, inset, 0, inset)
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
        if let _ = liveQuestion {
            return polls.count + 1
        } else {
            return polls.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.item == polls.count) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "liveQAnswerCardID", for: indexPath) as! LiveQAnswerCard
            cell.question = liveQuestion
            cell.questionLabel.text = liveQuestion.text
            cell.socket = socket
            return cell
        }
        let poll = polls[indexPath.item]
        if (poll.isLive) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "liveQAskedCardID", for: indexPath) as! LiveQAskedCard
            cell.socket = socket
            socket.delegate = cell
            cell.poll = poll
            cell.questionLabel.text = poll.text
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "closedQAnsweredCardID", for: indexPath) as! ClosedQAnsweredCard
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width * 0.9, height: frame.height * 0.6)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
