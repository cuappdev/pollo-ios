//
//  CollectionViewCell.swift
//  Clicker
//
//  Created by eoin on 4/17/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class LiveQAnswerCard: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, LiveOptionCellDelegate {
    
    var question: Question!
    var currentState: CurrentState!
    var totalNumResults: Int!
    var freeResponses: [String]!
    var isMCQuestion: Bool!
    
    
    var questionLabel: UILabel!
    var resultsTableView: UITableView!
    var totalResultsLabel: UILabel!
    var loadingView: UIImageView!
    
    var choice: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    func setupCell() {
        isMCQuestion = true
        let staticQuestion: Question = Question(1234, "What is my name?", "MULTIPLE_CHOICE", options: ["Jack", "Jason", "George", "Jimmy"])
        let staticCurrentState: CurrentState = CurrentState(1234, ["A": ["text": "Jack", "count": 2],
                                                                   "B": ["text": "Jason", "count": 5],
                                                                   "C": ["text": "George", "count": 3],
                                                                   "D": ["text": "Jimmy", "count": 7]],
                                                            ["1": "A"])
        question = staticQuestion
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
        questionLabel.text = question.text
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
        addSubview(resultsTableView)
        
        
        totalResultsLabel = UILabel()
        totalResultsLabel.text = "\(totalNumResults!) votes"
        totalResultsLabel.font = ._12MediumFont
        totalResultsLabel.textAlignment = .right
        totalResultsLabel.textColor = .clickerMediumGray
        addSubview(totalResultsLabel)
        
        loadingView = UIImageView(image: #imageLiteral(resourceName: "liveIcon"))
        loadingView.isHidden = true
        addSubview(loadingView)
        
    }
    
    func layoutViews() {
        
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
        
        totalResultsLabel.snp.updateConstraints { make in
            make.right.equalToSuperview().offset(-22.5)
            make.width.equalTo(50)
            make.bottom.equalToSuperview().offset(-22)
            make.height.equalTo(14.5)
        }
        
        loadingView.snp.makeConstraints { make in
            make.height.equalTo(14.5)
            make.width.equalTo(14.5)
            make.top.equalTo(totalResultsLabel.snp.top)
            make.left.equalToSuperview().offset(25)
        }
        
    }
    
    // MARK - TABLEVIEW
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCellID", for: indexPath) as! LiveOptionCell
        cell.buttonView.setTitle(question.options[indexPath.row], for: .normal)
        cell.delegate = self
        cell.index = indexPath.row
        cell.chosen = (choice == indexPath.row)
        cell.setColors()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question.options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 47
    }
    
    // MARK - OptionViewDelegate
    func choose(_ choice: Int) {
        print("reloding Data")
        self.choice = choice
        resultsTableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
