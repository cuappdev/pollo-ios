//
//  UserResultsViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 2/21/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit
import Presentr

class UserResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var pollCode: String!
    var question: Question!
    var currentState: CurrentState!
    var totalNumResults: Float = 0
    var freeResponses: [String]!
    var isMCQuestion: Bool!
    
    var codeBarButtonItem: UIBarButtonItem!
    var endSessionBarButtonItem: UIBarButtonItem!

    var questionLabel: UILabel!
    var resultsTableView: UITableView!
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerBackground
        
        // PREPROCESS CURRENT STATE DATA
        isMCQuestion = (question.options.count > 0)
        totalNumResults = Float(currentState.getTotalCount())
        freeResponses = currentState.getResponses()
        
        setupViews()
        setupConstraints()
    }
    
    // MARK - TABLEVIEW
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (isMCQuestion) { // MULTIPLE CHOICE
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultMCCellID", for: indexPath) as! ResultMCCell
            cell.choiceTag = indexPath.row
            cell.optionLabel.text = question.options[indexPath.row]
            cell.selectionStyle = .none
            
            guard let currState = currentState else {
                return cell
            }
            
            // UPDATE HIGHLIGHT VIEW WIDTH
            let mcOption: String = intToMCOption(indexPath.row)
            guard let info = currState.results[mcOption] as? [String:Any], let count = info["count"] as? Int else {
                return cell
            }
            cell.numberLabel.text = "\(count)"
            if (totalNumResults > 0) {
                let percentWidth = CGFloat(Float(count) / totalNumResults)
                let totalWidth = cell.frame.width - 36
                cell.highlightWidthConstraint.update(offset: percentWidth * totalWidth)
            } else {
                cell.highlightWidthConstraint.update(offset: 0)
            }
            return cell
            
        } else { // FREE RESPONSE
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultFRCellID", for: indexPath) as! ResultFRCell
            cell.freeResponseLabel.text = freeResponses[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isMCQuestion) {
            return question.options.count
        } else {
            return freeResponses.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (isMCQuestion) {
            return view.frame.height * 0.089
        } else {
            // CALCULATE CELL HEIGHT FOR FR
            let text = freeResponses[indexPath.row]
            let frameForMessage = NSString(string: text).boundingRect(with: CGSize(width: view.frame.width, height: 2000) , options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSAttributedStringKey.font: UIFont._16RegularFont], context: nil)
            let height = frameForMessage.height + 40
            return height
        }
    }
    
    
    // MARK - LAYOUT
    func setupViews() {

        questionLabel = UILabel()
        questionLabel.text = question.text
        questionLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        questionLabel.textColor = .clickerBlack
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.numberOfLines = 0
        view.addSubview(questionLabel)
        
        resultsTableView = UITableView()
        resultsTableView.backgroundColor = .clear
        resultsTableView.separatorStyle = .none
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.clipsToBounds = true
        resultsTableView.register(ResultMCCell.self, forCellReuseIdentifier: "resultMCCellID")
        resultsTableView.register(ResultFRCell.self, forCellReuseIdentifier: "resultFRCellID")
        view.addSubview(resultsTableView)
    }
    
    func setupConstraints() {
        questionLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.frame.width * 0.93, height: view.frame.height * 0.09))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        
        resultsTableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-5)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-5)
            }
            make.top.equalTo(questionLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - KEYBOARD
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

