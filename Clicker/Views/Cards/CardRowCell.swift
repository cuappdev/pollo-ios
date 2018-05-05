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
    var countLabel: UILabel!
    let askedIdenfitifer = "askedCardID"
    let bigAskedIdentifier = "bigAskedCardID"
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
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
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
        collectionView.register(BigAskedCard.self, forCellWithReuseIdentifier: bigAskedIdentifier)
        collectionView.register(AnswerSharedCard.self, forCellWithReuseIdentifier: answerSharedIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        addSubview(collectionView)
        
        countLabel = UILabel()
        countLabel.textAlignment = .center
        countLabel.backgroundColor = UIColor.clickerLabelGrey
        countLabel.layer.cornerRadius = 12
        countLabel.clipsToBounds = true
        addSubview(countLabel)
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(444)
            make.centerX.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.width.equalTo(42)
            make.height.equalTo(23)
        }
    }
    
    // MARK: - COLLECTIONVIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return polls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let poll = polls[indexPath.item]
        let numOptions: Int? = poll.options?.count
        switch (pollRole) {
        case .ask: // ASK
            if (poll.isShared)  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: askedSharedIdentifier, for: indexPath) as! AskedSharedCard
                cell.poll = poll
                cell.questionLabel.text = poll.text
                return cell
            } else {
                if numOptions! <= 4 {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: askedIdenfitifer, for: indexPath) as! AskedCard
                    cell.socket = socket
                    socket.addDelegate(cell)
                    cell.poll = poll
                    cell.questionLabel.text = poll.text
                    cell.endPollDelegate = endPollDelegate
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bigAskedIdentifier, for: indexPath) as! BigAskedCard
                    cell.socket = socket
                    socket.addDelegate(cell)
                    cell.poll = poll
                    cell.questionLabel.text = poll.text
                    let moreOptions = (poll.options?.count)! - 4
                    if moreOptions == 1 {
                        cell.moreOptionsLabel.text = "\(moreOptions) more option..."
                    } else {
                        cell.moreOptionsLabel.text = "\(moreOptions) more options..."
                    }
                    cell.endPollDelegate = endPollDelegate
                    return cell
                }
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
        let poll = polls[indexPath.item]
        if (pollRole == .ask && !poll.isShared) { // ASKED CARD
            return CGSize(width: frame.width * 0.9, height: 440)
        } else {
            return CGSize(width: frame.width * 0.9, height: 415)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // UPDATE COUNT LABEL
        let countString = "\(indexPath.item)/\(polls.count)"
        countLabel.attributedText = getCountLabelAttributedString(countString)
    }
    
    // Get attributed string for countLabel
    func getCountLabelAttributedString(_ countString: String) -> NSMutableAttributedString {
        let slashIndex = countString.index(of: "/")?.encodedOffset
        let attributedString = NSMutableAttributedString(string: countString, attributes: [
            .font: UIFont.systemFont(ofSize: 14.0, weight: .bold),
            .foregroundColor: UIColor.clickerMediumGray,
            .kern: 0.0
            ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(white: 1.0, alpha: 0.9), range: NSRange(location: 0, length: slashIndex!))
        return attributedString
    }
    
    // MARK: SCROLLVIEW METHODS
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            let indexPath = collectionView.indexPath(for: cell)
            guard let cellRect = collectionView.layoutAttributesForItem(at: indexPath!)?.frame else {
                return
            }
            if (collectionView.bounds.contains(cellRect)) {
                let countString = "\(indexPath!.item)/\(polls.count)"
                countLabel.attributedText = getCountLabelAttributedString(countString)
                break
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
