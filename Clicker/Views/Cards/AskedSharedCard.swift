//
//  AskedSharedCard.swift
//  Clicker
//
//  Created by eoin on 4/17/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class AskedSharedCard: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var poll: Poll!
    var freeResponses: [String]!
    var isMCQuestion: Bool!
    
    
    var questionLabel: UILabel!
    var resultsTableView: UITableView!
    var visibiltyLabel: UILabel!
    var totalResultsLabel: UILabel!
    var worldView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    func setupCell() {
        isMCQuestion = true
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
        visibiltyLabel.text = "Shared with group"
        visibiltyLabel.font = ._12MediumFont
        visibiltyLabel.textAlignment = .left
        visibiltyLabel.textColor = .clickerMediumGray
        addSubview(visibiltyLabel)
        
        
        totalResultsLabel = UILabel()
        totalResultsLabel.text = "17 votes"
        totalResultsLabel.font = ._12MediumFont
        totalResultsLabel.textAlignment = .right
        totalResultsLabel.textColor = .clickerMediumGray
        addSubview(totalResultsLabel)
        
        worldView = UIImageView(image: #imageLiteral(resourceName: "results_shared"))
        addSubview(worldView)
        
    }
    
    func layoutViews() {
        
        contentView.snp.makeConstraints { make in
            make.height.equalTo(398)
            make.width.equalTo(333)
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
        
        worldView.snp.makeConstraints { make in
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
        
    }
    
    // MARK - TABLEVIEW
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
