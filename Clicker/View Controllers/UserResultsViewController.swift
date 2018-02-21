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
    
    var codeBarButtonItem: UIBarButtonItem!
    var endSessionBarButtonItem: UIBarButtonItem!

    var questionLabel: UILabel!
    var optionResultsTableView: UITableView!
    
    var question: Question!
    var currentState: CurrentState!
    var totalNumResults: Float = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerBackground
        
        for value in currentState.results.values {
            if let v = value as? Int {
                totalNumResults += Float(v)
            }
        }
        
        setupNavBar()
        setupViews()
        setupConstraints()
        
    }
    
    @objc func endSession() {
        
    }
    
    @objc func closePoll() {
        print("close poll")
    }
    
    // MARK - Tableview methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultMCOptionCellID", for: indexPath) as! ResultMCOptionCell
        cell.choiceTag = indexPath.row
        cell.optionLabel.text = question.options[indexPath.row]
        let mcOption: String = intToMCOption(indexPath.row)
        print("results: \(currentState.results)")
        print("choice blah: \(currentState.results[mcOption]))")
        if let numSelected = currentState.results[mcOption] as? Int {
            print("nonzero width")
            let width = CGFloat(Float(numSelected) / totalNumResults)
            print("blah: \(cell.frame.width) \(cell.layer.frame.width)")
            cell.highlightWidthConstraint.update(offset: width * cell.frame.width)
        } else {
            print("zero width")
            cell.highlightWidthConstraint.update(offset: 0)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question.options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height * 0.08888888889
    }
    
    
    // MARK - Setup views
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
        optionResultsTableView.register(ResultMCOptionCell.self, forCellReuseIdentifier: "resultMCOptionCellID")
        view.addSubview(optionResultsTableView)
    
        
    }
    
    func setupConstraints() {
        questionLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.frame.width * 0.92, height: view.frame.height * 0.09))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        
        
        optionResultsTableView.snp.makeConstraints { make in
            make.width.equalTo(questionLabel.snp.width)
            make.bottom.equalToSuperview().offset(-5)
            make.top.equalTo(questionLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        
    }
    
    func setupNavBar() {
        let codeLabel = UILabel()
        let pollCode = UserDefaults.standard.value(forKey: "pollCode") as! String
        let codeAttributedString = NSMutableAttributedString(string: "SESSION CODE: \(pollCode)")
        codeAttributedString.addAttribute(.font, value: UIFont._16RegularFont, range: NSRange(location: 0, length: 13))
        codeAttributedString.addAttribute(.font, value: UIFont._16MediumFont, range: NSRange(location: 13, length: codeAttributedString.length - 13))
        codeLabel.attributedText = codeAttributedString
        codeLabel.textColor = .white
        codeLabel.backgroundColor = .clear
        codeBarButtonItem = UIBarButtonItem(customView: codeLabel)
        self.navigationItem.leftBarButtonItem = codeBarButtonItem
        
        let endSessionButton = UIButton()
        let endSessionAttributedString = NSMutableAttributedString(string: "End Session")
        endSessionAttributedString.addAttribute(.font, value: UIFont._16SemiboldFont, range: NSRange(location: 0, length: endSessionAttributedString.length))
        endSessionAttributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: endSessionAttributedString.length))
        endSessionButton.setAttributedTitle(endSessionAttributedString, for: .normal)
        endSessionButton.backgroundColor = .clear
        endSessionButton.addTarget(self, action: #selector(endSession), for: .touchUpInside)
        endSessionBarButtonItem = UIBarButtonItem(customView: endSessionButton)
        self.navigationItem.rightBarButtonItem = endSessionBarButtonItem
    }
    
    // MARK: - Keyboard
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

