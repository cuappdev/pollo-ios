//
//  LiveQuestionAskedCard.swift
//  Clicker
//
//  Created by eoin on 4/16/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class LiveQAskedCard: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, SocketDelegate {
    
    var socket: Socket!
    var poll: Poll!
    var currentState: CurrentState!
    var endPollDelegate: EndPollDelegate!
    var totalNumResults: Int = 0
    var freeResponses: [String]!
    var isMCQuestion: Bool!
    
    var cellColors: UIColor!
    
    var questionLabel: UILabel!
    var resultsTableView: UITableView!
    var visibiltyLabel: UILabel!
    var shareResultsButton: UIButton!
    var totalResultsLabel: UILabel!
    var eyeView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    func setupCell() {
        isMCQuestion = true
//        let staticQuestion: Question = Question(1234, "What is my name?", "MULTIPLE_CHOICE", options: ["Jack", "Jason", "George", "Jimmy"])
        let staticCurrentState: CurrentState = CurrentState(1234, ["A": ["text": "Jack", "count": 2],
                                                                   "B": ["text": "Jason", "count": 5],
                                                                   "C": ["text": "George", "count": 3],
                                                                   "D": ["text": "Jimmy", "count": 7]],
                                                            ["1": "A"])
//        question = staticQuestion
        currentState = staticCurrentState
        socket?.addDelegate(self)
        
        backgroundColor = .clickerNavBarLightGrey
        setupViews()
        layoutViews()
    }
    
    func setupViews() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clickerBorder.cgColor
        self.layer.shadowRadius = 2.5
        self.layer.cornerRadius = 15
        
        cellColors = .clickerHalfGreen
        
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
        resultsTableView.register(ResultCell.self, forCellReuseIdentifier: "resultCellID")
        addSubview(resultsTableView)
        
        visibiltyLabel = UILabel()
        visibiltyLabel.text = "Only you can see these results"
        visibiltyLabel.font = ._12MediumFont
        visibiltyLabel.textAlignment = .left
        visibiltyLabel.textColor = .clickerMediumGray
        addSubview(visibiltyLabel)
        
        shareResultsButton = UIButton()
        shareResultsButton.setTitleColor(.clickerDeepBlack, for: .normal)
        shareResultsButton.backgroundColor = .clear
        shareResultsButton.setTitle("End Question", for: .normal)
        shareResultsButton.titleLabel?.font = ._16SemiboldFont
        shareResultsButton.titleLabel?.textAlignment = .center
        shareResultsButton.layer.cornerRadius = 25.5
        shareResultsButton.layer.borderColor = UIColor.clickerDeepBlack.cgColor
        shareResultsButton.layer.borderWidth = 1.5
        shareResultsButton.addTarget(self, action: #selector(endQuestionAction), for: .touchUpInside)
        addSubview(shareResultsButton)
        
        totalResultsLabel = UILabel()
        totalResultsLabel.text = "\(totalNumResults) votes"
        totalResultsLabel.font = ._12MediumFont
        totalResultsLabel.textAlignment = .right
        totalResultsLabel.textColor = .clickerMediumGray
        addSubview(totalResultsLabel)
        
        eyeView = UIImageView(image: #imageLiteral(resourceName: "solo_eye"))
        addSubview(eyeView)        
    }
    
    func layoutViews() {
        
        questionLabel.snp.updateConstraints{ make in
            make.top.equalToSuperview().offset(18)
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
        }
        
        resultsTableView.snp.updateConstraints{ make in
            make.top.equalTo(questionLabel.snp.bottom).offset(17)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-51)
        }
        
        visibiltyLabel.snp.updateConstraints{ make in
            make.left.equalToSuperview().offset(46)
            make.width.equalTo(200)
            make.top.equalTo(shareResultsButton.snp.top).offset(-17)
            make.height.equalTo(14.5)
        }
        
        shareResultsButton.snp.updateConstraints{ make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
            make.height.equalTo(47)
            make.width.equalTo(292.5)
        }
        
        totalResultsLabel.snp.updateConstraints{ make in
            make.right.equalToSuperview().offset(-22.5)
            make.width.equalTo(50)
            make.top.equalTo(visibiltyLabel.snp.top)
            make.height.equalTo(14.5)
        }
        
        eyeView.snp.makeConstraints { make in
            make.height.equalTo(14.5)
            make.width.equalTo(14.5)
            make.top.equalTo(visibiltyLabel.snp.top)
            make.left.equalToSuperview().offset(25)
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
    
    // MARK  - ACTIONS
    @objc func endQuestionAction() {
        socket.socket.emit("server/poll/end", [])
        endPollDelegate.endedPoll()
        shareResultsButton.setTitleColor(.clickerWhite, for: .normal)
        shareResultsButton.backgroundColor = .clickerGreen
        shareResultsButton.setTitle("Share Results", for: .normal)
        shareResultsButton.titleLabel?.font = ._16SemiboldFont
        shareResultsButton.layer.borderWidth = 0
        
        cellColors = .clickerMint
        resultsTableView.reloadData()
        
        shareResultsButton.removeTarget(self, action: #selector(endQuestionAction), for: .touchUpInside)
        shareResultsButton.addTarget(self, action: #selector(shareQuestionAction), for: .touchUpInside)
    }
    
    @objc func shareQuestionAction() {
        socket.socket.emit("server/poll/results", [])
        shareResultsButton.removeFromSuperview()
        eyeView.image = #imageLiteral(resourceName: "results_shared")
        visibiltyLabel.text = "Shared with group"
        visibiltyLabel.textColor = .clickerGreen
        visibiltyLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-23.5)
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
