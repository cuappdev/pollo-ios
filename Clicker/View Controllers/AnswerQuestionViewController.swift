//
//  AnswerQuestionViewController.swift
//  Clicker
//
//  Created by Keivan Shahida on 2/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class AnswerQuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var codeBarButtonItem: UIBarButtonItem!
    var endSessionBarButtonItem: UIBarButtonItem!
    var questionLabel: UILabel!
    var submitAnswerButton: UIButton!
    
    var pollCode: String!
    var question: String!
    var options: [String]! = ["Tomato", "Orange", "Rooster", "Leaf"]
    
    var optionTableView: UITableView!
    
    
    //MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clickerBackground
        UINavigationBar.appearance().barTintColor = .clickerGreen
        
        setupNavBar()
        setupViews()
        setupConstraints()
    }
    
    func setupNavBar() {
        let codeLabel = UILabel()
        let codeAttributedString = NSMutableAttributedString(string: "SESSION CODE: \(pollCode ?? "------")")
        codeAttributedString.addAttribute(.font, value: UIFont._16RegularFont, range: NSRange(location: 0, length: 13))
        codeAttributedString.addAttribute(.font, value: UIFont._16MediumFont, range: NSRange(location: 13, length: codeAttributedString.length - 13))
        codeLabel.attributedText = codeAttributedString
        codeLabel.textColor = .white
        codeLabel.backgroundColor = .clear
        codeBarButtonItem = UIBarButtonItem(customView: codeLabel)
        self.navigationItem.leftBarButtonItem = codeBarButtonItem
        
        let endSessionButton = UIButton()
        let endSessionAttributedString = NSMutableAttributedString(string: "Exit Session")
        endSessionAttributedString.addAttribute(.font, value: UIFont._16SemiboldFont, range: NSRange(location: 0, length: endSessionAttributedString.length))
        endSessionAttributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: endSessionAttributedString.length))
        endSessionButton.setAttributedTitle(endSessionAttributedString, for: .normal)
        endSessionButton.backgroundColor = .clear
        endSessionButton.addTarget(self, action: #selector(endSession), for: .touchUpInside)
        endSessionBarButtonItem = UIBarButtonItem(customView: endSessionButton)
        self.navigationItem.rightBarButtonItem = endSessionBarButtonItem
    }
    
    func setupViews() {
        
        questionLabel = UILabel()
        questionLabel.text = "How did nature go from inanimate organic molecules to life?"
        questionLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        questionLabel.textColor = .clickerBlack
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.numberOfLines = 0
        view.addSubview(questionLabel)
        
        optionTableView = UITableView()
        optionTableView.delegate = self
        optionTableView.dataSource = self
        optionTableView.separatorStyle = .none
        optionTableView.clipsToBounds = true
        optionTableView.isScrollEnabled = false
        optionTableView.register(StudentMultipleChoiceCell.self, forCellReuseIdentifier: "studentMultipleChoiceCell")
        optionTableView.backgroundColor = .clear
        view.addSubview(optionTableView)
        
        submitAnswerButton = UIButton()
        submitAnswerButton.backgroundColor = .clickerBlue
        submitAnswerButton.layer.cornerRadius = 8
        submitAnswerButton.setTitle("Submit", for: .normal)
        submitAnswerButton.setTitleColor(.white, for: .normal)
        submitAnswerButton.titleLabel?.font = UIFont._18SemiboldFont
        // submitAnswerButton.addTarget(self, action: #selector(), for: .touchUpInside)
        view.addSubview(submitAnswerButton)
        view.bringSubview(toFront: submitAnswerButton)
    }
    
    func setupConstraints() {
        questionLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.frame.width * 0.92, height: view.frame.height * 0.09))
            make.centerX.equalToSuperview()
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(18)
        }
        
        optionTableView.snp.updateConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(questionLabel.snp.bottom).offset(18)
            make.bottom.equalTo(submitAnswerButton.snp.top).offset(18)
        }
        
        submitAnswerButton.snp.updateConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(55)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-18)
        }
    }
    
    // MARK: - KEYBOARD
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - TABLEVIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
        // return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentMultipleChoiceCell", for: indexPath) as! StudentMultipleChoiceCell
        cell.choiceTag = indexPath.section
        cell.optionLabel.text = options[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    // MARK: - SESSION
    @objc func endSession() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

