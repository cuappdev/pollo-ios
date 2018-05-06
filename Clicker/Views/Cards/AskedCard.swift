//
//  AskedCard.swift
//  Clicker
//
//  Created by eoin on 4/16/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class AskedCard: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, SocketDelegate {
    
    var socket: Socket!
    var poll: Poll!
    var endPollDelegate: EndPollDelegate!
    var expandCardDelegate: ExpandCardDelegate!
    var cardType: CardType!
    
    // Timer
    var timer: Timer!
    var elapsedSeconds: Int = 0
    
    // Question
    var totalNumResults: Int = 0
    var freeResponses: [String]!
    var hasChangedState: Bool = false
    var question: String!
    
    var highlightColor: UIColor!
    
    var timerLabel: UILabel!
    var cardView: UIView!
    var questionLabel: UILabel!
    var resultsTableView: UITableView!
    var graphicView: UIImageView!
    var visibiltyLabel: UILabel!
    var totalResultsLabel: UILabel!
    var questionButton: UIButton!
    
    // Expanded Card views
    var moreOptionsLabel: UILabel!
    var seeAllButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clickerDeepBlack
        setup()
    }
    
    func setupLive() {
        timerLabel = UILabel()
        timerLabel.text = "00:00"
        timerLabel.font = UIFont._14BoldFont
        timerLabel.textColor = .clickerMediumGray
        timerLabel.textAlignment = .center
        addSubview(timerLabel)
        
        timerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(3)
        }
        
        visibiltyLabel.text = "Only you can see these results"
        
        questionButton.setTitle("End Question", for: .normal)
        questionButton.backgroundColor = .clear
        questionButton.setTitleColor(.clickerDeepBlack, for: .normal)
        questionButton.layer.borderColor = UIColor.clickerDeepBlack.cgColor
        
        graphicView.image = #imageLiteral(resourceName: "solo_eye")
        
        runTimer()
        
        visibiltyLabel.snp.makeConstraints { make in
            make.bottom.equalTo(questionButton.snp.top).offset(-15)
        }
        
        cardView.snp.makeConstraints { make in
            make.height.equalTo(398)
        }
    }
    
    func setupEnded() {
        cardView.snp.makeConstraints { make in
            make.height.equalTo(398)
        }
        
        
        if (timerLabel != nil && timerLabel.isDescendant(of: self)) {
            timerLabel.removeFromSuperview()
            timer.invalidate()
        }
        
        questionButton.setTitle("Share Results", for: .normal)
        questionButton.backgroundColor = .clickerGreen
        questionButton.setTitleColor(.white, for: .normal)
        questionButton.layer.borderColor = UIColor.clickerGreen.cgColor
        
        highlightColor = .clickerMint
        
        resultsTableView.reloadData()
        
        visibiltyLabel.snp.makeConstraints { make in
            make.bottom.equalTo(questionButton.snp.top).offset(-15)
        }
    }
    
    func setupShared() {
        if (questionButton.isDescendant(of: self)) {
            questionButton.removeFromSuperview()
        }
        cardView.snp.makeConstraints { make in
            if (hasChangedState) {
                make.bottom.equalToSuperview().inset(65)
            }
        }
        
        visibiltyLabel.text = "Shared with group"
        
        graphicView.image = #imageLiteral(resourceName: "results_shared")
        
        visibiltyLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
        }
        
    }
    
    func setupOverflow(numOptions: Int) {
        if (numOptions <= 4) {
            return
        }
        cardView.snp.makeConstraints { make in
            make.height.equalTo(cardView.snp.height).offset(37.5)
        }
        
        moreOptionsLabel = UILabel()
        moreOptionsLabel.text = "\(numOptions - 4) more options..."
        moreOptionsLabel.font = UIFont._12SemiboldFont
        moreOptionsLabel.textColor = .clickerDeepBlack
        addSubview(moreOptionsLabel)
        
        moreOptionsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.top.equalTo(resultsTableView.snp.bottom).offset(9)
        }
        
        seeAllButton = UIButton()
        seeAllButton.setTitle("See All", for: .normal)
        seeAllButton.setTitleColor(.clickerBlue, for: .normal)
        seeAllButton.titleLabel?.font = UIFont._12SemiboldFont
        seeAllButton.addTarget(self, action: #selector(seeAllAction), for: .touchUpInside)
        addSubview(seeAllButton)
        
        seeAllButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(resultsTableView.snp.bottom).offset(9)
        }
    }
    
    func setup() {
        highlightColor = .clickerHalfGreen
        
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
        resultsTableView.register(ResultCell.self, forCellReuseIdentifier: "resultCellID")
        cardView.addSubview(resultsTableView)
        
        visibiltyLabel = UILabel()
        visibiltyLabel.font = ._12MediumFont
        visibiltyLabel.textAlignment = .left
        visibiltyLabel.textColor = .clickerMediumGray
        cardView.addSubview(visibiltyLabel)
        
        questionButton = UIButton()
        questionButton.titleLabel?.font = ._16SemiboldFont
        questionButton.titleLabel?.textAlignment = .center
        questionButton.layer.cornerRadius = 25.5
        questionButton.layer.borderWidth = 1.5
        questionButton.addTarget(self, action: #selector(questionAction), for: .touchUpInside)
        cardView.addSubview(questionButton)
        
        totalResultsLabel = UILabel()
        totalResultsLabel.text = "\(totalNumResults) votes"
        totalResultsLabel.font = ._12MediumFont
        totalResultsLabel.textAlignment = .right
        totalResultsLabel.textColor = .clickerMediumGray
        cardView.addSubview(totalResultsLabel)
        
        graphicView = UIImageView()
        cardView.addSubview(graphicView)
        
        layoutViews()
    }
    
    func setupCard() {
        switch (cardType) {
        case .live:
            setupLive()
        case .ended:
            setupEnded()
        default:
            setupShared()
        }
        setupOverflow(numOptions: (poll.options?.count)!)
    }
    
    func layoutViews() {
        
        cardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.bottom.equalToSuperview()
            make.width.equalTo(339)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        questionLabel.snp.makeConstraints{ make in
            questionLabel.sizeToFit()
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(17)
            make.right.equalToSuperview().offset(17)
        }
        
        resultsTableView.snp.makeConstraints{ make in
            make.top.equalTo(questionLabel.snp.bottom).offset(13.5)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(206)
        }
        
        graphicView.snp.makeConstraints { make in
            make.width.height.equalTo(14.5)
            make.left.equalToSuperview().offset(16)
            make.centerY.equalTo(visibiltyLabel.snp.centerY)
        }
        
        visibiltyLabel.snp.makeConstraints{ make in
            make.left.equalTo(graphicView.snp.right).offset(4)
            make.width.equalTo(200)
            make.height.equalTo(14.5)
        }
        
        totalResultsLabel.snp.makeConstraints{ make in
            make.right.equalToSuperview().offset(-22.5)
            make.width.equalTo(50)
            make.height.equalTo(14.5)
            make.centerY.equalTo(visibiltyLabel.snp.centerY)
        }
        
        questionButton.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
            make.height.equalTo(47)
            make.width.equalTo(303)
        }
        
        
    }
    
    func configure(with poll: Poll) {
        questionLabel.text = poll.text
    }
    
    // MARK - TABLEVIEW
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCellID", for: indexPath) as! ResultCell
        cell.choiceTag = indexPath.row
        cell.selectionStyle = .none
        cell.highlightView.backgroundColor = highlightColor
        
        // UPDATE HIGHLIGHT VIEW WIDTH
        let mcOption: String = intToMCOption(indexPath.row)
        var count: Int = 0
        if let choiceInfo = poll.results![mcOption] as? [String:Any] {
            cell.optionLabel.text = choiceInfo["text"] as? String
            count = choiceInfo["count"] as! Int
            cell.numberLabel.text = "\(count)"
        }
        
        if (totalNumResults > 0) {
            let percentWidth = CGFloat(Float(count) / Float(totalNumResults))
            let totalWidth = cell.frame.width
            cell.highlightWidthConstraint.update(offset: percentWidth * totalWidth)
        } else {
            cell.highlightWidthConstraint.update(offset: 0)
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min((poll.options?.count)!, 4)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 47
    }
    
    func sessionConnected() { }
    
    func sessionDisconnected() { }
    
    func receivedUserCount(_ count: Int) { }
    
    func pollStarted(_ poll: Poll) { }
    
    func pollEnded(_ poll: Poll) { }
    
    func receivedResults(_ currentState: CurrentState) {
        totalNumResults = currentState.getTotalCount()
        poll.results = currentState.results
        DispatchQueue.main.async { self.resultsTableView.reloadData() }
    }
    
    func saveSession(_ session: Session) { }
    
    func updatedTally(_ currentState: CurrentState) {
        totalNumResults = currentState.getTotalCount()
        poll.results = currentState.results
        DispatchQueue.main.async { self.resultsTableView.reloadData() }
    }
    
    // MARK: Start timer
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
    }
    
    // MARK  - ACTIONS
    // Update timer label
    @objc func updateTimerLabel() {
        elapsedSeconds += 1
        if (elapsedSeconds < 10) {
            timerLabel.text = "00:0\(elapsedSeconds)"
        } else if (elapsedSeconds < 60) {
            timerLabel.text = "00:\(elapsedSeconds)"
        } else {
            let minutes = Int(elapsedSeconds / 60)
            let seconds = elapsedSeconds - minutes * 60
            if (elapsedSeconds < 600) {
                if (seconds < 10) {
                    timerLabel.text = "0\(minutes):0\(seconds)"
                } else {
                    timerLabel.text = "0\(minutes):\(seconds)"
                }
            } else {
                if (seconds < 10) {
                    timerLabel.text = "\(minutes):0\(seconds)"
                } else {
                    timerLabel.text = "\(minutes):\(seconds)"
                }
            }
        }
    }
    
    @objc func questionAction() {
        hasChangedState = true
        switch (cardType) {
        case .live:
            socket.socket.emit("server/poll/end", [])
            endPollDelegate.endedPoll()
            setupEnded()
            cardType = .ended
            poll.isLive = false
        case .ended:
            socket.socket.emit("server/poll/results", [])
            setupShared()
            cardType = .shared
            poll.isShared = true
        default: break
        }
    }
    
    @objc func seeAllAction() {
        print("see all")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
