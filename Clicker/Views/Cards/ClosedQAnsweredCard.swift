//
//  PastQAnsweredCard.swift
//  Clicker
//
//  Created by eoin on 4/17/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

//
//  CollectionViewCell.swift
//  Clicker
//
//  Created by eoin on 4/17/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class ClosedQAnsweredCard: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var currentState: CurrentState!
    var poll: Poll!
    var totalNumResults: Int!
    var freeResponses: [String]!
    var isMCQuestion: Bool!
    
    
    var questionLabel: UILabel!
    var resultsTableView: UITableView!
    var totalResultsLabel: UILabel!
    var closedLabel: UILabel!
    
    var choice: Int?
    
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
        
        totalNumResults = Int(currentState.getTotalCount())
        
        backgroundColor = .clickerNavBarLightGrey
        setupViews()
        layoutViews()
    }
    
    func setupViews() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clickerBorder.cgColor
        self.layer.shadowRadius = 2.5
        self.layer.cornerRadius = 15
        
        questionLabel = UILabel()
        questionLabel.text = "QUESTION"
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
        resultsTableView.register(ClosedOptionCell.self, forCellReuseIdentifier: "closedOptionCellID")
        addSubview(resultsTableView)
        
        
        totalResultsLabel = UILabel()
        totalResultsLabel.text = "\(totalNumResults!) votes"
        totalResultsLabel.font = ._12MediumFont
        totalResultsLabel.textAlignment = .right
        totalResultsLabel.textColor = .clickerMediumGray
        addSubview(totalResultsLabel)
        
        closedLabel = UILabel()
        closedLabel.text = "Poll has closed"
        closedLabel.font = ._12SemiboldFont
        closedLabel.textColor = .clickerDeepBlack
        closedLabel.textAlignment = .left
        addSubview(closedLabel)
        
    }
    
    func layoutViews() {
        
        questionLabel.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
        }
        
        resultsTableView.snp.updateConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(17)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-51)
        }
        
        totalResultsLabel.snp.updateConstraints { make in
            make.right.equalToSuperview().offset(-22.5)
            make.width.equalTo(50)
            make.bottom.equalToSuperview().offset(-22)
            make.height.equalTo(14.5)
        }
        
        closedLabel.snp.makeConstraints { make in
            make.height.equalTo(14.5)
            make.width.equalToSuperview().dividedBy(2)
            make.top.equalTo(totalResultsLabel.snp.top)
            make.left.equalToSuperview().offset(25)
        }
        
    }
    
    // MARK - TABLEVIEW
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "closedOptionCellID", for: indexPath) as! ClosedOptionCell
        cell.questionLabel.text = poll.options?[indexPath.row]
        cell.index = indexPath.row
        cell.chosen = (yourChoice() == indexPath.row)
        cell.setColors()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poll.options!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 47
    }
    
    func yourChoice() -> Int {
        return 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

