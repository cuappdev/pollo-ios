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

class CardView: UIView, UITableViewDelegate, UITableViewDataSource, LiveOptionCellDelegate {
    
    var choice: Int?
    var totalNumResults: Int = 0
    let textFieldPadding = 18
    let textFieldHeight = 48
    var highlightColor: UIColor!
    
    var topView: UIView!
    var questionLabel: UILabel!
    var responseTextField: UITextField!
    
    var scrollView: UIScrollView!
    var scrollContentView: UIView!
    var resultsTableView: UITableView!
    var graphicView: UIImageView!
    var visibilityLabel: UILabel!
    var totalResultsLabel: UILabel!
    var questionButton: UIButton!
    var infoLabel: UILabel!
    
    var cardDelegate: CardDelegate!
    var userRole: UserRole!
    var cardType: CardType!
    var questionType: QuestionType!
    var poll: Poll!
    var frResults: [(String, Int)] = []
    var tableViewHeightConstraint: Constraint!
    
    let cornerRadius = 15
    let optionCellHeight = 47
    let resultIdentifier = "resultCellID"
    let resultFRIdentifier = "resultFRCellID"
    let optionIdentifier = "optionCellID"
    
    init(frame: CGRect, userRole: UserRole, cardDelegate: CardDelegate) {
        super.init(frame: frame)
        
        self.userRole = userRole
        self.cardDelegate = cardDelegate
        
        if #available(iOS 11.0, *) {
            layer.cornerRadius = CGFloat(cornerRadius)
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            let path =  UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            layer.mask = maskLayer
        }
        
        backgroundColor = .clickerDeepBlack
        
        setupViews()
        setupConstraints()
    }
    
    func configure() {
        if (questionType == .freeResponse) {
            self.frResults = poll.getFRResultsArray()
        }
        let height = (poll.options?.count)! * optionCellHeight
        tableViewHeightConstraint.update(offset: height + 10)
    }
    
    func setupViews() {
        topView = UIView()
        topView.backgroundColor = .clickerWhite
        if #available(iOS 11.0, *) {
            topView.layer.cornerRadius = CGFloat(cornerRadius)
            topView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            let path =  UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            topView.layer.mask = maskLayer
        }
        addSubview(topView)
        
        questionLabel = UILabel()
        questionLabel.font = ._22SemiboldFont
        questionLabel.textColor = .clickerBlack
        questionLabel.textAlignment = .left
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.numberOfLines = 0
        topView.addSubview(questionLabel)
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = .clickerDeepBlack
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        addSubview(scrollView)
        
        scrollContentView = UIView()
        scrollContentView.backgroundColor = .clickerDeepBlack
        scrollView.addSubview(scrollContentView)
        
        resultsTableView = UITableView()
        resultsTableView.backgroundColor = .white
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.separatorStyle = .none
        resultsTableView.isScrollEnabled = false
        resultsTableView.register(ResultCell.self, forCellReuseIdentifier: resultIdentifier)
        resultsTableView.register(ResultFRCell.self, forCellReuseIdentifier: resultFRIdentifier)
        resultsTableView.register(LiveOptionCell.self, forCellReuseIdentifier: optionIdentifier)
        if #available(iOS 11.0, *) {
            resultsTableView.layer.cornerRadius = 15
            resultsTableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            let path =  UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            resultsTableView.layer.mask = maskLayer
        }
        scrollContentView.addSubview(resultsTableView)
        
//        totalResultsLabel = UILabel()
//        totalResultsLabel.text = "\(totalNumResults) votes"
//        totalResultsLabel.font = ._12MediumFont
//        totalResultsLabel.textAlignment = .right
//        totalResultsLabel.textColor = .clickerMediumGray
//        addSubview(totalResultsLabel)
        
        if (userRole == .admin) {
            setupAdminViews()
            setupAdminConstraints()
        } else { // member
            setupMemberViews()
            setupMemberConstraints()
        }
        
    }
    
    func setupAdminViews() {
//        visibilityLabel = UILabel()
//        visibilityLabel.font = ._12MediumFont
//        visibilityLabel.textAlignment = .left
//        visibilityLabel.textColor = .clickerMediumGray
//        addSubview(visibilityLabel)
//
        questionButton = UIButton()
        questionButton.backgroundColor = .clickerTransparentGrey
        questionButton.setTitleColor(.white, for: .normal)
        questionButton.titleLabel?.font = ._16SemiboldFont
        questionButton.titleLabel?.textAlignment = .center
        questionButton.layer.cornerRadius = 23.5
        questionButton.layer.borderWidth = 1.5
        questionButton.layer.borderColor = UIColor.white.cgColor
        questionButton.addTarget(self, action: #selector(questionAction), for: .touchUpInside)
        addSubview(questionButton)
//
//        graphicView = UIImageView()
//        addSubview(graphicView)
    }
    
    func setupAdminConstraints() {
//        visibilityLabel.snp.makeConstraints{ make in
//            make.left.equalTo(graphicView.snp.right).offset(4)
//            make.width.equalTo(200)
//            make.height.equalTo(14.5)
//        }
//
//        graphicView.snp.makeConstraints { make in
//            make.width.height.equalTo(14.5)
//            make.left.equalToSuperview().offset(16)
//            make.centerY.equalTo(visibilityLabel.snp.centerY)
//        }
//
        questionButton.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(28)
            make.height.equalTo(47)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
//
//        totalResultsLabel.snp.makeConstraints { make in
//            make.centerY.equalTo(visibilityLabel.snp.centerY)
//        }
    }
    
    func setupMemberViews() {
        if (questionType == .freeResponse) {
//            responseTextField = UITextField()
//            responseTextField.layer.cornerRadius = 45
//            responseTextField.placeholder = "Type a response"
//            responseTextField.font = ._16MediumFont
//            responseTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: textFieldPadding, height: textFieldHeight))
//            responseTextField.leftViewMode = .always
//            addSubview(responseTextField)
        }
        
//        infoLabel = UILabel()
//        infoLabel.font = ._12SemiboldFont
//        addSubview(infoLabel)
    }
    
    func setupMemberConstraints() {
//        if (questionType == .freeResponse) {
//            responseTextField.snp.makeConstraints { make in
//                make.top.equalTo(questionLabel.snp.bottom).offset(13.5)
//                make.centerY.equalToSuperview()
//                make.width.equalToSuperview().multipliedBy(0.9)
//                make.height.equalTo(textFieldHeight)
//            }
//        }
//
//        infoLabel.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(18)
//            make.bottom.equalToSuperview().inset(24)
//            make.height.equalTo(15)
//        }
//
//        totalResultsLabel.snp.makeConstraints { make in
//            make.centerY.equalTo(infoLabel.snp.centerY)
//        }
    }
    
    func setupConstraints() {
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(76)
        }
        
        questionLabel.snp.makeConstraints{ make in
            questionLabel.sizeToFit()
            make.top.equalToSuperview().offset(20)
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
            make.height.equalToSuperview()
        }
        
        resultsTableView.snp.makeConstraints{ make in
//            if (questionType == .freeResponse && userRole == .member) {
//                make.top.equalTo(responseTextField.snp.bottom).offset(18)
//            } else {
//                make.top.equalTo(questionLabel.snp.bottom).offset(13.5)
//            }
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            tableViewHeightConstraint = make.height.equalTo(0).constraint
        }
        
//        totalResultsLabel.snp.makeConstraints{ make in
//            make.right.equalToSuperview().offset(-22.5)
//            make.width.equalTo(50)
//            make.height.equalTo(14.5)
//        }
        
        if (userRole == .admin) {
            setupAdminConstraints()
        } else {
            setupMemberConstraints()
        }
    }
    
    func setupOverflow(numOptions: Int) {
        if (numOptions <= 4) {
            return
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
        setupOverflow(numOptions: (poll.options?.count)!)
    }
    
    func setupLive() {
        if (userRole == .admin) {
//            visibilityLabel.text = "Only you can see these results"
//
            questionButton.setTitle("End Question", for: .normal)
//
//            graphicView.image = #imageLiteral(resourceName: "solo_eye")
//
//            visibilityLabel.snp.makeConstraints { make in
//                make.bottom.equalTo(questionButton.snp.top).offset(-15)
            }
//        } else {
//            infoLabel.textColor = .clickerMediumGray
//        }
    }
    
    func setupEnded() {
        if (userRole == .admin) {
            questionButton.setTitle("Share Results", for: .normal)
//
//            highlightColor = .clickerMint
//
//            resultsTableView.reloadData()
//
//            visibilityLabel.snp.makeConstraints { make in
//                make.bottom.equalTo(questionButton.snp.top).offset(-15)
            }
//        } else {
//            infoLabel.textColor = .clickerDeepBlack
//            infoLabel.text = "Poll has closed"
//        }
    }
    
    func setupShared() {
//        if (userRole == .admin) {
//            if (questionButton.isDescendant(of: self)) {
//                questionButton.removeFromSuperview()
//            }
//            visibilityLabel.text = "Shared with group"
//
//            graphicView.image = #imageLiteral(resourceName: "results_shared")
//
//            visibilityLabel.snp.makeConstraints { make in
//                make.bottom.equalToSuperview().offset(-20)
//            }
//
//        } else {
//            infoLabel.textColor = .clickerDeepBlack
//            infoLabel.text = "Poll has closed"
//        }
    }
    
    // MARK - TABLEVIEW
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (questionType == .freeResponse) {
            let cell = tableView.dequeueReusableCell(withIdentifier: resultFRIdentifier, for: indexPath) as! ResultFRCell
            let responseCountTuple = frResults[indexPath.row]
            cell.response = responseCountTuple.0
            cell.count = responseCountTuple.1
            cell.configure()
            return cell
        }
        // ADMIN
        if (userRole == .admin) {
            let cell = tableView.dequeueReusableCell(withIdentifier: resultIdentifier, for: indexPath) as! ResultCell
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
            let cell = tableView.dequeueReusableCell(withIdentifier: resultIdentifier, for: indexPath) as! ResultCell
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
        if (questionType == .freeResponse) {
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
    
    // MARK - OptionViewDelegate
    func choose(_ choice: Int) {
        if (poll.isLive) {
            let answer: [String:Any] = [
                "googleId": User.currentUser?.id,
                "poll": poll.id,
                "choice": intToMCOption(choice),
                "text": poll.options![choice]
            ]
            cardDelegate.emitTally(answer: answer)
            self.choice = choice
            resultsTableView.reloadData()
            infoLabel.text = "Vote Sumbitted"
        }
    }
    
    // MARK: ACTIONS
    
    @objc func seeAllAction() {
        print("see all")
    }

    @objc func questionAction() {
        cardDelegate.questionBtnPressed()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
