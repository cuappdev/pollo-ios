//
//  AnswerCard.swift
//  Clicker
//
//  Created by eoin on 4/17/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class AnswerCard: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, LiveOptionCellDelegate, SocketDelegate {
    
    var freeResponses: [String]!
    
    var questionLabel: UILabel!
    var resultsTableView: UITableView!
    var totalResultsLabel: UILabel!
    var infoLabel: UILabel!
    
    var choice: Int?
    var poll: Poll!
    var socket: Socket!
    var expandCardDelegate: ExpandCardDelegate!
    
    var cardType: CardType!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        backgroundColor = .clickerNavBarLightGrey
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
        // TODO
    }
    
    func configure(with poll: Poll) {
        questionLabel.text = poll.text
    }
    
    func setupViews() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clickerBorder.cgColor
        self.layer.shadowRadius = 2.5
        self.layer.cornerRadius = 15
        
        questionLabel = UILabel()
        questionLabel.font = ._22SemiboldFont
        questionLabel.textColor = .clickerBlack
        questionLabel.textAlignment = .left
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.numberOfLines = 0
        addSubview(questionLabel)
        
        resultsTableView = UITableView()
        resultsTableView.backgroundColor = .clear
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.separatorStyle = .none
        resultsTableView.isScrollEnabled = false
        resultsTableView.register(LiveOptionCell.self, forCellReuseIdentifier: "optionCellID")
        resultsTableView.register(ResultCell.self, forCellReuseIdentifier: "resultCellID")
        addSubview(resultsTableView)
        
        infoLabel = UILabel()
        infoLabel.font = ._12SemiboldFont
        addSubview(infoLabel)
        
    }
    
    func layoutViews() {
        
        contentView.snp.makeConstraints { make in
            make.height.equalTo(336)
            make.width.equalTo(339)
        }
        
        questionLabel.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
        }
        
        resultsTableView.snp.updateConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(17)
            make.left.equalToSuperview()//.offset(18)
            make.right.equalToSuperview()//.offset(-18)
            make.bottom.equalToSuperview().offset(-51)
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
        return poll.options!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 47
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
