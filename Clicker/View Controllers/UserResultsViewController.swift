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
    
    var codeBarButtonItem: UIBarButtonItem!
    var endSessionBarButtonItem: UIBarButtonItem!

    var questionLabel: UILabel!
    var optionResultsTableView: UITableView!
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerBackground
        
        totalNumResults = Float(currentState.getCountFromResults())
        
        setupViews()
        setupConstraints()
    }
    
    // MARK - TABLEVIEW
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultMCCellID", for: indexPath) as! ResultMCCell
        cell.choiceTag = indexPath.row
        cell.optionLabel.text = question.options[indexPath.row]
        let mcOption: String = intToMCOption(indexPath.row)
        guard let info = currentState.results[mcOption] as? [String:Any], let count = info["count"] as? Int else {
            return cell
        }
        cell.numberLabel.text = "\(count)"
        if (totalNumResults > 0) {
            let width = CGFloat(Float(count) / totalNumResults)
            cell.highlightWidthConstraint.update(offset: width * cell.frame.width)
        } else {
            cell.highlightWidthConstraint.update(offset: 0)
        }
        cell.layoutIfNeeded()
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question.options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height * 0.08888888889
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
        
        optionResultsTableView = UITableView()
        optionResultsTableView.backgroundColor = .clear
        optionResultsTableView.separatorStyle = .none
        optionResultsTableView.delegate = self
        optionResultsTableView.dataSource = self
        optionResultsTableView.clipsToBounds = true
        optionResultsTableView.register(ResultMCCell.self, forCellReuseIdentifier: "resultMCCellID")
        view.addSubview(optionResultsTableView)
    }
    
    func setupConstraints() {
        questionLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.frame.width * 0.93, height: view.frame.height * 0.09))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        
        optionResultsTableView.snp.makeConstraints { make in
            make.width.equalTo(questionLabel.snp.width)
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

