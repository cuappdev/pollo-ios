//
//  CardView.swift
//  Clicker
//
//  Created by Kevin Chan on 5/6/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

protocol CardDelegate {
    func questionBtnPressed()
    func emitTally(answer: [String:Any])
    func upvote(answer: [String:Any])
}

class CardView: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MultipleChoiceDelegate {
    
    var choice: Int?
    var totalNumResults: Int = 0
    var highlightColor: UIColor!
    
    var topView: UIView!
    var questionLabel: UILabel!
    var responseTextField: UITextField!
    
    var scrollView: UIScrollView!
    var scrollContentView: UIView!
    var resultsTableView: UITableView!
    var blackView: UIView!
    
    var graphicView: UIImageView!
    var visibilityLabel: UILabel!
    var totalResultsLabel: UILabel!
    var questionButton: UIButton!
    var infoLabel: UILabel!
    
    var cardDelegate: CardDelegate!
    var userRole: UserRole!
    var cardType: CardType!
    var poll: Poll!
    var frResults: [(String, Int)] = []
    var topViewHeightConstraint: Constraint!
    var tableViewHeightConstraint: Constraint!
    
    // MARK: Constants
    let textFieldPadding = 18
    let textFieldHeight = 48
    let cornerRadius = 15
    let optionCellHeight = 47
    let frCellHeight = 64
    let minTableViewHeight = 254
    let tableViewTopPadding = 18
    
    init(frame: CGRect, userRole: UserRole, cardDelegate: CardDelegate) {
        super.init(frame: frame)
        
        self.userRole = userRole
        self.cardDelegate = cardDelegate
        
        layer.cornerRadius = CGFloat(cornerRadius)
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        backgroundColor = .clickerBlack1
        
        setupViews()
        setupConstraints()
    }
    
    func configure() {
        if (userRole == .member && poll.questionType == .freeResponse) {
            topViewHeightConstraint.update(offset: 140)
        } else {
            topViewHeightConstraint.update(offset: 102)
        }
        
        if (poll.questionType == .multipleChoice) {
            setupTotalResultsLabel()
        }
        
        if (userRole == .admin) {
            setupAdminViews()
            setupAdminConstraints()
        } else { // member
            setupMemberViews()
            setupMemberConstraints()
        }
        
        if (poll.questionType == .freeResponse) {
            self.frResults = poll.getFRResultsArray()
            let numResults = frResults.count
            if (numResults < 5) {
                scrollView.isScrollEnabled = false
                tableViewHeightConstraint.update(offset: minTableViewHeight)
            } else {
                updateTableViewHeightForFR()
            }
        } else {
            let numOptions = poll.options.count
            updateTableViewHeight(baseHeight: numOptions * optionCellHeight)
            if (numOptions <= 7) {
                scrollView.isScrollEnabled = false
            }
        }
    }
    
    func setupViews() {
        topView = UIView()
        topView.backgroundColor = .clickerWhite
        topView.layer.cornerRadius = CGFloat(cornerRadius)
        topView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addSubview(topView)
        
        questionLabel = UILabel()
        questionLabel.font = ._22SemiboldFont
        questionLabel.textColor = .clickerBlack0
        questionLabel.textAlignment = .left
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.numberOfLines = 0
        topView.addSubview(questionLabel)
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = .clickerBlack1
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        addSubview(scrollView)
        
        scrollContentView = UIView()
        scrollContentView.backgroundColor = .white
        scrollContentView.layer.cornerRadius = 15
        scrollContentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        scrollView.addSubview(scrollContentView)
        
        resultsTableView = UITableView()
        resultsTableView.backgroundColor = .white
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.separatorStyle = .none
        resultsTableView.isScrollEnabled = false
        resultsTableView.showsVerticalScrollIndicator = false
        resultsTableView.register(ResultMCCell.self, forCellReuseIdentifier: Identifiers.resultMCIdentifier)
        resultsTableView.register(ResultFRCell.self, forCellReuseIdentifier: Identifiers.resultFRIdentifier)
        resultsTableView.register(LiveOptionCell.self, forCellReuseIdentifier: Identifiers.optionIdentifier)
        resultsTableView.layer.cornerRadius = 15
        resultsTableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        scrollContentView.addSubview(resultsTableView)
        
        blackView = UIView()
        blackView.backgroundColor = .clickerBlack1
        scrollContentView.addSubview(blackView)
        scrollContentView.sendSubview(toBack: blackView)
        
//        let shadowLayer = CAGradientLayer()
//        shadowLayer.frame = CGRect(x: 0, y: frame.height - 92, width: frame.width, height: 92)
//        shadowLayer.colors = [UIColor.clickerGradientGrey.cgColor, UIColor.black.cgColor]
//        layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func setupTotalResultsLabel() {
        totalResultsLabel = UILabel()
        totalResultsLabel.text = "\(totalNumResults) votes"
        totalResultsLabel.font = ._12MediumFont
        totalResultsLabel.textAlignment = .right
        totalResultsLabel.textColor = .clickerGrey2
        topView.addSubview(totalResultsLabel)
        
        totalResultsLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(16)
        }
    }
    
    func setupConstraints() {
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            topViewHeightConstraint = make.height.equalTo(0).constraint
        }
        
        questionLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(44)
            make.left.equalToSuperview().offset(17)
            make.right.equalToSuperview().inset(17)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(2)
        }
        
        resultsTableView.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(18)
            make.left.right.equalToSuperview()
            tableViewHeightConstraint = make.height.equalTo(0).constraint
        }
        
        blackView.snp.makeConstraints { make in
            // Move blackView above resultsTableView's bottom to show corners
            make.top.equalTo(resultsTableView.snp.bottom).inset(10)
            make.left.right.bottom.equalToSuperview()
        }
    
    }

    func setupAdminViews() {
        graphicView = UIImageView()
        topView.addSubview(graphicView)
        
        visibilityLabel = UILabel()
        visibilityLabel.font = ._12MediumFont
        visibilityLabel.textAlignment = .left
        visibilityLabel.textColor = .clickerGrey2
        topView.addSubview(visibilityLabel)
        
        questionButton = UIButton()
        questionButton.backgroundColor = .clickerGrey9
        questionButton.setTitleColor(.white, for: .normal)
        questionButton.titleLabel?.font = ._16SemiboldFont
        questionButton.titleLabel?.textAlignment = .center
        questionButton.layer.cornerRadius = 23.5
        questionButton.layer.borderWidth = 1
        questionButton.layer.borderColor = UIColor.white.cgColor
        questionButton.addTarget(self, action: #selector(questionAction), for: .touchUpInside)
        addSubview(questionButton)
        bringSubview(toFront: questionButton)
        
    }
    
    func setupAdminConstraints() {

        visibilityLabel.snp.makeConstraints{ make in
            make.left.equalTo(graphicView.snp.right).offset(4)
            make.height.equalTo(14.5)
            make.bottom.equalToSuperview().inset(15)
        }
        
        graphicView.snp.makeConstraints { make in
            make.width.height.equalTo(14.5)
            make.left.equalToSuperview().offset(16)
            make.centerY.equalTo(visibilityLabel.snp.centerY)
        }
        
        questionButton.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(34)
            make.height.equalTo(47)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    func setupMemberViews() {
        if (poll.questionType == .freeResponse) {
            responseTextField = UITextField()
            responseTextField.backgroundColor = .white
            responseTextField.placeholder = "Type a response"
            responseTextField.font = ._16MediumFont
            responseTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: textFieldPadding, height: textFieldHeight))
            responseTextField.layer.cornerRadius = 20
            responseTextField.layer.borderWidth = 1
            responseTextField.layer.borderColor = UIColor.clickerGrey5.cgColor
            responseTextField.leftViewMode = .always
            responseTextField.returnKeyType = .send
            responseTextField.delegate = self
            topView.addSubview(responseTextField)
        } else {
            infoLabel = UILabel()
            infoLabel.font = ._12SemiboldFont
            topView.addSubview(infoLabel)
        }
    }
    
    func setupMemberConstraints() {
        if (poll.questionType == .freeResponse) {
            responseTextField.snp.makeConstraints { make in
                make.top.equalTo(questionLabel.snp.bottom).offset(13.5)
                make.centerX.equalToSuperview()
                make.width.equalTo(306)
                make.height.equalTo(textFieldHeight)
            }
        } else {
            infoLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(18)
                make.centerY.equalTo(totalResultsLabel.snp.centerY)
                make.height.equalTo(15)
            }
        }
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
    }
    
    func setupLive() {
        if (userRole == .admin) {
            if (poll.state == .shared) {
                visibilityLabel.text = "Shared with group"
                graphicView.image = #imageLiteral(resourceName: "liveIcon")
            } else {
                visibilityLabel.text = "Only you can see these results"
                graphicView.image = #imageLiteral(resourceName: "solo_eye")
            }
            
            questionButton.setTitle("End Question", for: .normal)
            
        } else {
            if (poll.questionType == .multipleChoice) {
                infoLabel.textColor = .clickerGrey2
            }
        }
    }
    
    func setupEnded() {
        if (userRole == .admin) {
            if (poll.state == .shared) {
                visibilityLabel.text = "Shared with group"
                graphicView.image = #imageLiteral(resourceName: "liveIcon")
            } else {
                visibilityLabel.text = "Only you can see these results"
                graphicView.image = #imageLiteral(resourceName: "solo_eye")
            }
            
            if (poll.questionType == .multipleChoice) {
                questionButton.setTitle("Share Results", for: .normal)
            } else {
                questionButton.removeFromSuperview()
            }
            
            highlightColor = .clickerGreen2
            
            resultsTableView.reloadData()
            
        } else {
            if (poll.questionType == .multipleChoice) {
                infoLabel.textColor = .clickerBlack1
                infoLabel.text = "Poll has closed"
            }
        }
    }
    
    func setupShared() {
        if (userRole == .admin) {
            if (questionButton.isDescendant(of: self)) {
                questionButton.removeFromSuperview()
            }
            visibilityLabel.text = "Shared with group"
            
            graphicView.image = #imageLiteral(resourceName: "results_shared")
        } else {
            if (poll.questionType == .multipleChoice) {
                infoLabel.textColor = .clickerBlack1
                infoLabel.text = "Poll has closed"
            }
        }
    }
    
    // MARK: UPDATE TABLE VIEW HEIGHT CONSTRAINT
    func updateTableViewHeight(baseHeight: Int) {
        let height = max(baseHeight + tableViewTopPadding + 10, minTableViewHeight)
        tableViewHeightConstraint.update(offset: height)
    }
    
    func updateTableViewHeightForFR() {
        let numFRResults = frResults.count
        if (numFRResults >= 5) {
            updateTableViewHeight(baseHeight: self.frResults.count * frCellHeight)
        }
    }
    
    // MARK - TABLEVIEW
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (poll.questionType == .freeResponse) {
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.resultFRIdentifier, for: indexPath) as! ResultFRCell
            let responseCountTuple = frResults[indexPath.row]
            cell.response = responseCountTuple.0
            cell.count = responseCountTuple.1
            cell.configure()
            return cell
        }
        // ADMIN
        if (userRole == .admin) {
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.resultMCIdentifier, for: indexPath) as! ResultMCCell
            cell.choiceTag = indexPath.row
            cell.selectionStyle = .none
            cell.highlightView.backgroundColor = highlightColor
            
            // UPDATE HIGHLIGHT VIEW WIDTH
            let mcOption: String = intToMCOption(indexPath.row)
            var count: Int = 0
            if let choiceInfo = poll.results[mcOption] as? [String:Any] {
                cell.optionLabel.text = choiceInfo["text"] as? String
                count = choiceInfo["count"] as! Int
                cell.numberLabel.text = "\(count)"
            }
            
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
        // MEMBER
        switch cardType {
        case .live, .ended:
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.optionIdentifier, for: indexPath) as! LiveOptionCell
            cell.buttonView.setTitle(poll.options[indexPath.row], for: .normal)
            cell.delegate = self
            cell.index = indexPath.row
            cell.chosen = (choice == indexPath.row)
            cell.setColors(isLive: poll.state == .live)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.resultMCIdentifier, for: indexPath) as! ResultMCCell
            cell.choiceTag = indexPath.row
            cell.optionLabel.text = poll.options[indexPath.row]
            cell.selectionStyle = .none
            cell.highlightView.backgroundColor = .clickerGreen2
            
            // UPDATE HIGHLIGHT VIEW WIDTH
            let mcOption: String = intToMCOption(indexPath.row)
            guard let info = poll.results[mcOption] as? [String:Any], let count = info["count"] as? Int else {
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
        if (poll.questionType == .freeResponse) {
            return frResults.count
        } else {
            return poll.options.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (poll.questionType == .freeResponse) ? CGFloat(frCellHeight) : CGFloat(optionCellHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (poll.questionType == .freeResponse && userRole == .member) {
            // upvote
            let upvotedResponse = frResults[indexPath.row].0
            let answer: [String:Any] = [
                "googleId": User.currentUser?.id ?? 0,
                "poll": poll.id ?? 0,
                "choice": upvotedResponse,
                "text": upvotedResponse
            ]
            cardDelegate.upvote(answer: answer)
            // update cell subviews
            let upvotedCell = tableView.cellForRow(at: indexPath) as! ResultFRCell
            upvotedCell.countLabel.textColor = .clickerBlue
            upvotedCell.triangleImageView.image = #imageLiteral(resourceName: "blueTriangle")
        }
    }
    
    // MARK: SCROLLVIEW METHODS
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            if (poll.options.count > 7) {
                let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, scrollView.contentOffset.y, 0.0)
                self.scrollView.contentInset = contentInsets
            }
        }
    }
    
    // MARK - MultipleChoiceDelegate
    func choose(_ choice: Int) {
        if (poll.state == .live) {
            let answer: [String:Any] = [
                "googleId": User.currentUser?.id ?? 0,
                "poll": poll.id ?? 0,
                "choice": intToMCOption(choice),
                "text": poll.options[choice]
            ]
            cardDelegate.emitTally(answer: answer)
            self.choice = choice
            resultsTableView.reloadData()
            infoLabel.text = "Vote Sumbitted"
        }
    }
    
    // MARK: TEXTFIELD DELEGATE
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == responseTextField) {
            print("submitted free response")
            let freeResponse = responseTextField.text
            let answer: [String:Any] = [
                "googleId": User.currentUser?.id ?? 0,
                "poll": poll.id ?? 0,
                "choice": freeResponse ?? "",
                "text": freeResponse ?? ""
            ]
            cardDelegate.emitTally(answer: answer)
            responseTextField.text = ""
        }
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: ACTIONS
    
    @objc func questionAction() {
        if (userRole == .admin) {
            cardDelegate.questionBtnPressed()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
