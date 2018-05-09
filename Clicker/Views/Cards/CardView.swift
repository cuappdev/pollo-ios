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
    
    // Constants
    let textFieldPadding = 18
    let textFieldHeight = 48
    let cornerRadius = 15
    let optionCellHeight = 47
    let tableViewTopPadding = 18
    let resultMCIdentifier = "resultMCCellID"
    let resultFRIdentifier = "resultFRCellID"
    let optionIdentifier = "optionCellID"
    
    init(frame: CGRect, userRole: UserRole, cardDelegate: CardDelegate) {
        super.init(frame: frame)
        
        self.userRole = userRole
        self.cardDelegate = cardDelegate
        
        layer.cornerRadius = CGFloat(cornerRadius)
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        backgroundColor = .clickerDeepBlack
        
        setupViews()
        setupConstraints()
    }
    
    func configure() {
        if (poll.questionType == .multipleChoice) {
            setupTotalResultsLabel()
        }
        
        if (userRole == .admin) {
            setupAdminViews()
            setupAdminConstraints()
        } else { // member
            if (poll.questionType == .freeResponse) {
                topViewHeightConstraint.update(offset: 140)
            } else {
                topViewHeightConstraint.update(offset: 102)
            }
            setupMemberViews()
            setupMemberConstraints()
        }
        
        if (poll.questionType == .freeResponse) {
            self.frResults = poll.getFRResultsArray()
            tableViewHeightConstraint.update(offset: 254)
        } else {
            let numOptions = (poll.options?.count)!
            let height = numOptions * optionCellHeight + tableViewTopPadding + 10
            tableViewHeightConstraint.update(offset: height)
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
        questionLabel.textColor = .clickerBlack
        questionLabel.textAlignment = .left
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.numberOfLines = 0
        topView.addSubview(questionLabel)
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = .white
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
        resultsTableView.register(ResultMCCell.self, forCellReuseIdentifier: resultMCIdentifier)
        resultsTableView.register(ResultFRCell.self, forCellReuseIdentifier: resultFRIdentifier)
        resultsTableView.register(LiveOptionCell.self, forCellReuseIdentifier: optionIdentifier)
        resultsTableView.layer.cornerRadius = 15
        resultsTableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        scrollContentView.addSubview(resultsTableView)
        
        blackView = UIView()
        blackView.backgroundColor = .clickerDeepBlack
        scrollContentView.addSubview(blackView)
        
    }
    
    func setupTotalResultsLabel() {
        totalResultsLabel = UILabel()
        totalResultsLabel.text = "\(totalNumResults) votes"
        totalResultsLabel.font = ._12MediumFont
        totalResultsLabel.textAlignment = .right
        totalResultsLabel.textColor = .clickerMediumGray
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
            make.top.left.right.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        resultsTableView.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(18)
            make.left.right.equalToSuperview()
            tableViewHeightConstraint = make.height.equalTo(0).constraint
        }
        
        blackView.snp.makeConstraints { make in
            make.top.equalTo(resultsTableView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    
    }
    
    func setupButton() {
        
    }
    
    func setupAdminViews() {
        if (poll.questionType == .multipleChoice) {
            graphicView = UIImageView()
            topView.addSubview(graphicView)
            
            visibilityLabel = UILabel()
            visibilityLabel.font = ._12MediumFont
            visibilityLabel.textAlignment = .left
            visibilityLabel.textColor = .clickerMediumGray
            topView.addSubview(visibilityLabel)
        }
        
        questionButton = UIButton()
        questionButton.backgroundColor = .clickerTransparentGrey
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
        if (poll.questionType == .multipleChoice) {
            graphicView.snp.makeConstraints { make in
                make.width.height.equalTo(14.5)
                make.left.equalToSuperview().offset(16)
                make.centerY.equalTo(totalResultsLabel.snp.centerY)
            }
            
            visibilityLabel.snp.makeConstraints{ make in
                make.left.equalTo(graphicView.snp.right).offset(4)
                make.height.equalTo(14.5)
                make.centerY.equalTo(totalResultsLabel.snp.centerY)
            }
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
            responseTextField.layer.cornerRadius = 15
            responseTextField.placeholder = "Type a response"
            responseTextField.font = ._16MediumFont
            responseTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: textFieldPadding, height: textFieldHeight))
            responseTextField.layer.cornerRadius = 45
            responseTextField.layer.borderWidth = 1
            responseTextField.layer.borderColor = UIColor.clickerBorder.cgColor
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
            visibilityLabel.text = "Only you can see these results"
            
            questionButton.setTitle("End Question", for: .normal)
            
            graphicView.image = #imageLiteral(resourceName: "solo_eye")
        } else {
            if (poll.questionType == .multipleChoice) {
                infoLabel.textColor = .clickerMediumGray
            }
        }
    }
    
    func setupEnded() {
        if (userRole == .admin) {
            questionButton.setTitle("Share Results", for: .normal)
            
            highlightColor = .clickerMint
            
            resultsTableView.reloadData()
            
        } else {
            if (poll.questionType == .multipleChoice) {
                infoLabel.textColor = .clickerDeepBlack
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
                infoLabel.textColor = .clickerDeepBlack
                infoLabel.text = "Poll has closed"
            }
        }
    }
    
    // MARK - TABLEVIEW
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (poll.questionType == .freeResponse) {
            let cell = tableView.dequeueReusableCell(withIdentifier: resultFRIdentifier, for: indexPath) as! ResultFRCell
            let responseCountTuple = frResults[indexPath.row]
            cell.response = responseCountTuple.0
            cell.count = responseCountTuple.1
            cell.configure()
            return cell
        }
        // ADMIN
        if (userRole == .admin) {
            let cell = tableView.dequeueReusableCell(withIdentifier: resultMCIdentifier, for: indexPath) as! ResultMCCell
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
        // MEMBER
        switch cardType {
        case .live, .ended:
            let cell = tableView.dequeueReusableCell(withIdentifier: optionIdentifier, for: indexPath) as! LiveOptionCell
            cell.buttonView.setTitle(poll.options?[indexPath.row], for: .normal)
            cell.delegate = self
            cell.index = indexPath.row
            cell.chosen = (choice == indexPath.row)
            cell.setColors(isLive: poll.isLive)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: resultMCIdentifier, for: indexPath) as! ResultMCCell
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
        if (poll.questionType == .freeResponse) {
            return frResults.count
        } else {
            return (poll.options?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(optionCellHeight)
    }
    
    // MARK: SCROLLVIEW METHODS
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            //            print("scrolling")
            //            print(scrollView.contentOffset.y)
            //            let height = (poll.options?.count)! * optionCellHeight
            //            let diff = frame.height - CGFloat(height) - scrollView.contentOffset.y - 179
            //            print("DIFFERENCE: \(diff)")
            if ((poll.options?.count)! > 7) {
                let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, scrollView.contentOffset.y, 0.0)
                resultsTableView.contentInset = contentInsets
                self.scrollView.contentInset = contentInsets
            }
        }
    }
    
    // MARK - MultipleChoiceDelegate
    func choose(_ choice: Int) {
        if (poll.isLive) {
            let answer: [String:Any] = [
                "googleId": User.currentUser?.id ?? 0,
                "poll": poll.id ?? 0,
                "choice": intToMCOption(choice),
                "text": poll.options![choice]
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
