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
    var timer: Timer!
    var elapsedSeconds: Int = 0
    var totalNumResults: Int = 0
    var freeResponses: [String]!
    var isMCQuestion: Bool!
    
    var cellColors: UIColor!
    
    var timerLabel: UILabel!
    var cardView: UIView!
    var questionLabel: UILabel!
    var resultsTableView: UITableView!
    var visibiltyLabel: UILabel!
    var endQuestionButton: UIButton!
    var totalResultsLabel: UILabel!
    var eyeView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        runTimer()
    }
    
    func setupCell() {
        isMCQuestion = true

        socket?.addDelegate(self)
        
        backgroundColor = .clickerDeepBlack
        setupViews()
        layoutViews()
    }
    
    func setupViews() {
        cellColors = .clickerHalfGreen
        
        timerLabel = UILabel()
        timerLabel.text = "00:00"
        timerLabel.font = UIFont._14BoldFont
        timerLabel.textColor = .clickerMediumGray
        timerLabel.textAlignment = .center
        addSubview(timerLabel)
        
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
        visibiltyLabel.text = "Only you can see these results"
        visibiltyLabel.font = ._12MediumFont
        visibiltyLabel.textAlignment = .left
        visibiltyLabel.textColor = .clickerMediumGray
        cardView.addSubview(visibiltyLabel)
        
        endQuestionButton = UIButton()
        endQuestionButton.setTitleColor(.clickerDeepBlack, for: .normal)
        endQuestionButton.backgroundColor = .clear
        endQuestionButton.setTitle("End Question", for: .normal)
        endQuestionButton.titleLabel?.font = ._16SemiboldFont
        endQuestionButton.titleLabel?.textAlignment = .center
        endQuestionButton.layer.cornerRadius = 25.5
        endQuestionButton.layer.borderColor = UIColor.clickerDeepBlack.cgColor
        endQuestionButton.layer.borderWidth = 1.5
        endQuestionButton.addTarget(self, action: #selector(endQuestionAction), for: .touchUpInside)
        cardView.addSubview(endQuestionButton)
        
        totalResultsLabel = UILabel()
        totalResultsLabel.text = "\(totalNumResults) votes"
        totalResultsLabel.font = ._12MediumFont
        totalResultsLabel.textAlignment = .right
        totalResultsLabel.textColor = .clickerMediumGray
        cardView.addSubview(totalResultsLabel)
        
        eyeView = UIImageView(image: #imageLiteral(resourceName: "solo_eye"))
        cardView.addSubview(eyeView)
    }
    
    func layoutViews() {
        
        timerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(3)
        }
        
        cardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.height.equalTo(390)
            make.width.equalTo(339)
            make.centerX.equalToSuperview()
        }
        
        questionLabel.snp.updateConstraints{ make in
            questionLabel.sizeToFit()
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(17)
            make.right.equalToSuperview().offset(17)
        }
        
        resultsTableView.snp.updateConstraints{ make in
            make.top.equalTo(questionLabel.snp.bottom).offset(13.5)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(206)
        }
        
        visibiltyLabel.snp.updateConstraints{ make in
            make.top.equalTo(resultsTableView.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(46)
            make.width.equalTo(200)
            make.height.equalTo(14.5)
        }
        
        eyeView.snp.makeConstraints { make in
            make.height.equalTo(14.5)
            make.width.equalTo(14.5)
            make.centerY.equalTo(visibiltyLabel.snp.centerY)
            make.left.equalToSuperview().offset(25)
        }
        
        totalResultsLabel.snp.updateConstraints{ make in
            make.right.equalToSuperview().offset(-22.5)
            make.width.equalTo(50)
            make.top.equalTo(visibiltyLabel.snp.top)
            make.height.equalTo(14.5)
        }
        
        endQuestionButton.snp.updateConstraints{ make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
            make.height.equalTo(47)
            make.top.equalTo(visibiltyLabel.snp.bottom).offset(15)
            make.width.equalTo(303)
        }
        
        
    }
    
    // MARK - TABLEVIEW
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCellID", for: indexPath) as! ResultCell
        cell.choiceTag = indexPath.row
        cell.selectionStyle = .none
        cell.highlightView.backgroundColor = cellColors
        
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
        
        // ANIMATE CHANGE
        UIView.animate(withDuration: 0.5, animations: {
            cell.layoutIfNeeded()
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poll.options!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 47
    }
    
    func sessionConnected() {
        
    }
    
    func sessionDisconnected() {
        
    }
    
    func pollStarted(_ poll: Poll) {
    }
    
    func pollEnded(_ poll: Poll) {
    }
    
    func receivedResults(_ currentState: CurrentState) {
    }
    
    func saveSession(_ session: Session) {
    }
    
    func updatedTally(_ currentState: CurrentState) {
        totalNumResults = currentState.getTotalCount()
        poll.results = currentState.results
        self.resultsTableView.reloadData()
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
    
    @objc func endQuestionAction() {
        socket.socket.emit("server/poll/end", [])
        endPollDelegate.endedPoll()
        
        timer.invalidate()
        timerLabel.removeFromSuperview()
        
        endQuestionButton.setTitleColor(.clickerWhite, for: .normal)
        endQuestionButton.backgroundColor = .clickerGreen
        endQuestionButton.setTitle("Share Results", for: .normal)
        endQuestionButton.titleLabel?.font = ._16SemiboldFont
        endQuestionButton.layer.borderWidth = 0
        
        cellColors = .clickerMint
        resultsTableView.reloadData()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
