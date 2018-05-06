//
//  CardView.swift
//  Clicker
//
//  Created by Kevin Chan on 5/6/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

protocol QuestionButtonDelegate {
    func questionBtnPressed()
}

class CardView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var totalNumResults: Int = 0
    var highlightColor: UIColor!
    
    var questionLabel: UILabel!
    var resultsTableView: UITableView!
    var graphicView: UIImageView!
    var visibiltyLabel: UILabel!
    var totalResultsLabel: UILabel!
    var questionButton: UIButton!
    
    var questionButtonDelegate: QuestionButtonDelegate!
    var userRole: UserRole!
    var poll: Poll!
    var cardHeight: Int!
    var cardHeightConstraint: Constraint!
    
    // Expanded Card views
    var moreOptionsLabel: UILabel!
    var seeAllButton: UIButton!
    
    init(frame: CGRect, userRole: UserRole, questionButtonDelegate: QuestionButtonDelegate) {
        super.init(frame: frame)
        
        self.userRole = userRole
        self.questionButtonDelegate = questionButtonDelegate
        
        layer.cornerRadius = 15
        layer.borderColor = UIColor.clickerBorder.cgColor
        layer.borderWidth = 1
        layer.shadowRadius = 2.5
        backgroundColor = .clickerNavBarLightGrey
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
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
        visibiltyLabel.font = ._12MediumFont
        visibiltyLabel.textAlignment = .left
        visibiltyLabel.textColor = .clickerMediumGray
        addSubview(visibiltyLabel)
        
        if (userRole == .admin) {
            questionButton = UIButton()
            questionButton.titleLabel?.font = ._16SemiboldFont
            questionButton.titleLabel?.textAlignment = .center
            questionButton.layer.cornerRadius = 25.5
            questionButton.layer.borderWidth = 1.5
            questionButton.addTarget(self, action: #selector(questionAction), for: .touchUpInside)
            addSubview(questionButton)
        }
        
        totalResultsLabel = UILabel()
        totalResultsLabel.text = "\(totalNumResults) votes"
        totalResultsLabel.font = ._12MediumFont
        totalResultsLabel.textAlignment = .right
        totalResultsLabel.textColor = .clickerMediumGray
        addSubview(totalResultsLabel)
        
        graphicView = UIImageView()
        addSubview(graphicView)
    }
    
    func setupConstraints() {
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
        
        if (userRole == .admin) {
            questionButton.snp.makeConstraints{ make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().inset(24)
                make.height.equalTo(47)
                make.width.equalTo(303)
            }
        }
    }
    
    func setupOverflow(numOptions: Int) {
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
            make.centerY.equalTo(moreOptionsLabel.snp.centerY)
        }
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
    
    // MARK: ACTIONS
    
    @objc func seeAllAction() {
        print("see all")
    }

    @objc func questionAction() {
        questionButtonDelegate.questionBtnPressed()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
