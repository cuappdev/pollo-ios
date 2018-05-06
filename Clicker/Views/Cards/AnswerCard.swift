//
//  AnswerCard.swift
//  Clicker
//
//  Created by eoin on 4/17/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class AnswerCard: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, LiveOptionCellDelegate, SocketDelegate {
    
    var freeResponses: [String]!
    
    var cardView: UIView!
    var questionLabel: UILabel!
    var resultsTableView: UITableView!
    var totalResultsLabel: UILabel!
    var infoLabel: UILabel!
    var moreOptionsLabel: UILabel!
    var seeAllButton: UIButton!
    
    var choice: Int?
    var poll: Poll!
    var socket: Socket!
    var expandCardDelegate: ExpandCardDelegate!
    var cardHeightConstraint: Constraint!
    
    var cardType: CardType!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        backgroundColor = .clickerDeepBlack
        setupViews()
        layoutViews()
    }
    
    func setupCard() {
        switch cardType {
        case .live:
            setupLive()
        case .ended:
            setupEnded()
        default: // shared
            setupShared()
        }
        setupOverflow(numOptions: (poll.options?.count)!)
    }
    
    func setupLive() {
        infoLabel.textColor = .clickerMediumGray
    }
    
    func setupEnded() {
        infoLabel.textColor = .clickerDeepBlack
        infoLabel.text = "Poll has closed"
    }
    
    func setupShared() {
        infoLabel.textColor = .clickerDeepBlack
        infoLabel.text = "Poll has closed"
    }
    
    func setupOverflow(numOptions: Int) {
        if (numOptions <= 4) {
            return
        }
        
        moreOptionsLabel = UILabel()
        moreOptionsLabel.text = "\(numOptions - 4) more options..."
        moreOptionsLabel.font = UIFont._12SemiboldFont
        moreOptionsLabel.textColor = .clickerDeepBlack
        cardView.addSubview(moreOptionsLabel)
        
        moreOptionsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.top.equalTo(resultsTableView.snp.bottom).offset(9)
        }
        
        seeAllButton = UIButton()
        seeAllButton.setTitle("See All", for: .normal)
        seeAllButton.setTitleColor(.clickerBlue, for: .normal)
        seeAllButton.titleLabel?.font = UIFont._12SemiboldFont
        seeAllButton.addTarget(self, action: #selector(seeAllAction), for: .touchUpInside)
        cardView.addSubview(seeAllButton)
        
        seeAllButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(moreOptionsLabel.snp.centerY)
        }
    }
    
    func configure(with poll: Poll) {
        questionLabel.text = poll.text
    }
    
    func setupViews() {
        cardView = UIView()
        cardView.layer.cornerRadius = 15
        cardView.layer.borderColor = UIColor.clickerBorder.cgColor
        cardView.layer.borderWidth = 1
        cardView.layer.shadowRadius = 2.5
        cardView.backgroundColor = .clickerNavBarLightGrey
        addSubview(cardView)
        
        questionLabel = UILabel()
        questionLabel.font = ._22SemiboldFont
        questionLabel.textColor = .clickerBlack
        questionLabel.textAlignment = .left
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.numberOfLines = 0
        cardView.addSubview(questionLabel)
        
        resultsTableView = UITableView()
        resultsTableView.backgroundColor = .clear
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.separatorStyle = .none
        resultsTableView.isScrollEnabled = false
        resultsTableView.register(LiveOptionCell.self, forCellReuseIdentifier: "optionCellID")
        resultsTableView.register(ResultCell.self, forCellReuseIdentifier: "resultCellID")
        cardView.addSubview(resultsTableView)
        
        infoLabel = UILabel()
        infoLabel.font = ._12SemiboldFont
        cardView.addSubview(infoLabel)
        
    }
    
    func layoutViews() {
        
        cardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            cardHeightConstraint = make.height.equalTo(339).constraint
        }
        
        questionLabel.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
        }
        
        resultsTableView.snp.updateConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(13.5)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(206)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.bottom.equalToSuperview().inset(24)
            make.height.equalTo(15)
        }
        
    }
    
    // MARK - TABLEVIEW
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cardType {
        case .live, .ended:
            let cell = tableView.dequeueReusableCell(withIdentifier: "optionCellID", for: indexPath) as! LiveOptionCell
            cell.buttonView.setTitle(poll.options?[indexPath.row], for: .normal)
            cell.delegate = self
            cell.index = indexPath.row
            cell.chosen = (choice == indexPath.row)
            cell.setColors(isLive: poll.isLive)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultCellID", for: indexPath) as! ResultCell
            cell.choiceTag = indexPath.row
            cell.optionLabel.text = poll.options?[indexPath.row]
            cell.selectionStyle = .none
            cell.highlightView.backgroundColor = .clickerMint
            
            // UPDATE HIGHLIGHT VIEW WIDTH
            let mcOption: String = intToMCOption(indexPath.row)
            guard let info = poll.results![mcOption] as? [String:Any], let count = info["count"] as? Int else {
                return cell
            }
            cell.numberLabel.text = "\(count)"
            let totalNumResults = poll.getTotalResults()
            if (totalNumResults > 0) {
                let percentWidth = CGFloat(Float(count) / Float(totalNumResults))
                let totalWidth = cell.frame.width
                cell.highlightWidthConstraint.update(offset: percentWidth * totalWidth)
            } else {
                cell.highlightWidthConstraint.update(offset: 0)
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(poll.options!.count, 4)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 47
    }

    // MARK: Actions
    @objc func seeAllAction() {
        print("see all")
    }
    
    // MARK - OptionViewDelegate
    func choose(_ choice: Int) {
        if (poll.isLive) {
            let answer: [String:Any] = [
                "googleId": User.currentUser?.id,
                "poll": poll.id,
                "choice": intToMCOption(choice),
                "text": poll.options![choice]
            ]
            socket.socket.emit("server/poll/tally", answer)
            self.choice = choice
            resultsTableView.reloadData()
            infoLabel.text = "Vote Sumbitted"
        }
    }
    
    // MARK: SOCKET DELEGATE
    func sessionConnected() { }
    
    func sessionDisconnected() { }
    
    func receivedUserCount(_ count: Int) { }
    
    func pollStarted(_ poll: Poll) { }
    
    func pollEnded(_ poll: Poll) {
        print(choice)
        self.poll.isLive = false
        DispatchQueue.main.async { self.resultsTableView.reloadData() }
        cardType = .ended
        setupEnded()
    }
    
    func receivedResults(_ currentState: CurrentState) {
        poll.isShared = true
        poll.results = currentState.results
        DispatchQueue.main.async { self.resultsTableView.reloadData() }
        cardType = .shared
        setupShared()
    }
    
    func saveSession(_ session: Session) { }
    
    func updatedTally(_ currentState: CurrentState) { }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
