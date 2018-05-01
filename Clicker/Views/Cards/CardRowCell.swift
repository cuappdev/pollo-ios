//
//  DateCell.swift
//  Clicker
//
//  Created by eoin on 4/15/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

enum PollRole {
    case ask
    case answer
}

class CardRowCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    let askedIdenfitifer = "askedCardID"
    let askedSharedIdentifier = "askedSharedCardID"
    let answerIdentifier = "answerCardID"
    let answerSharedIdentifier = "answerSharedCardID"
    var socket: Socket!
    var polls: [Poll]!
    var pollRole: PollRole!
    var endPollDelegate: EndPollDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        setupViews()
        setupConstraints()
    }
    
    
    func setupViews() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 18
        layout.scrollDirection = .horizontal
        collectionView.alwaysBounceHorizontal = true
        let inset = (frame.width - CGFloat(frame.width * 0.9)) / 2.0
        collectionView.contentInset = UIEdgeInsetsMake(0, inset, 0, inset)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AskedCard.self, forCellWithReuseIdentifier: askedIdenfitifer)
        collectionView.register(AskedSharedCard.self, forCellWithReuseIdentifier: askedSharedIdentifier)
        collectionView.register(AnswerCard.self, forCellWithReuseIdentifier: answerIdentifier)
        collectionView.register(AnswerSharedCard.self, forCellWithReuseIdentifier: answerSharedIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        addSubview(collectionView)
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(35)
            make.width.equalToSuperview()
            make.height.equalTo(444)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - COLLECTIONVIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return polls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let poll = polls[indexPath.item]
        switch (pollRole) {
        case .ask: // ASK
            if (poll.isShared)  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: askedSharedIdentifier, for: indexPath) as! AskedSharedCard
                cell.poll = poll
                cell.questionLabel.text = poll.text
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: askedIdenfitifer, for: indexPath) as! AskedCard
                cell.socket = socket
                socket.addDelegate(cell)
                cell.poll = poll
                cell.questionLabel.text = poll.text
                cell.endPollDelegate = endPollDelegate
                return cell
            }
        default: // ANSWER
            if (poll.isShared) { // SHARED
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: answerSharedIdentifier, for: indexPath) as! AnswerSharedCard
                cell.poll = poll
                cell.questionLabel.text = poll.text
                cell.resultsTableView.reloadData()
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: answerIdentifier, for: indexPath) as! AnswerCard
                cell.socket = socket
                socket.addDelegate(cell)
                cell.poll = poll
                cell.questionLabel.text = poll.text
                cell.resultsTableView.reloadData()
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width * 0.9, height: 415)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
