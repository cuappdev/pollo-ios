//
//  CreateMultipleChoiceCell.swift
//  Clicker
//
//  Created by Kevin Chan on 2/6/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import SnapKit
import UIKit

class CreateMultipleChoiceCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MultipleChoiceOptionDelegate {
    
    var createQuestionVC: CreateQuestionViewController!
    var questionTextField: UITextField!
    var optionsTableView: UITableView!
    var startPollButton: UIButton!
    var numOptions: Int = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clickerBackground
        
        setupViews()
        layoutSubviews()
    }
    
    @objc func startPoll() {
        let liveResultsVC = LiveResultsViewController()
        
        //Pass values to LiveResultsVC
        liveResultsVC.question = questionTextField.text
        
        var options: [String] = [String]()
        for index in 0...numOptions - 1 {
            let indexPath = IndexPath(row: 0, section: index)
            let optionCell = optionsTableView.cellForRow(at: indexPath) as! CreateMultipleChoiceOptionCell
            options.append(optionCell.addOptionTextField.text!)
        }
        liveResultsVC.options = options
        createQuestionVC.navigationController?.pushViewController(liveResultsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == numOptions) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addMoreOptionCellID") as! AddMoreOptionCell
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "createMultipleChoiceOptionCellID") as! CreateMultipleChoiceOptionCell
        cell.choiceTag = indexPath.section
        cell.mcOptionDelegate = self
        cell.selectionStyle = .none
        
        if numOptions <= 2 {
            cell.trashButton.isUserInteractionEnabled = false
            cell.trashButton.alpha = 0.0
        } else {
            cell.trashButton.isUserInteractionEnabled = true
            cell.trashButton.alpha = 1.0
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == numOptions) {
            let indexSet = NSIndexSet(index: numOptions)
            numOptions += 1
            tableView.insertSections(indexSet as IndexSet, with: .none)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numOptions + 1 // 1 extra for the "Add More" cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return frame.height * 0.1049618321
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func setupViews() {
        questionTextField = UITextField()
        questionTextField.placeholder = "Add Question"
        questionTextField.font = UIFont.systemFont(ofSize: 21)
        questionTextField.backgroundColor = .white
        questionTextField.layer.sublayerTransform = CATransform3DMakeTranslation(18, 0, 0)
        questionTextField.returnKeyType = UIReturnKeyType.done
        questionTextField.delegate = self
        addSubview(questionTextField)
        
        optionsTableView = UITableView()
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        optionsTableView.register(CreateMultipleChoiceOptionCell.self, forCellReuseIdentifier: "createMultipleChoiceOptionCellID")
        optionsTableView.register(AddMoreOptionCell.self, forCellReuseIdentifier: "addMoreOptionCellID")
        optionsTableView.backgroundColor = .clickerBackground
        optionsTableView.clipsToBounds = true
        optionsTableView.separatorStyle = .none
        addSubview(optionsTableView)
        
        startPollButton = UIButton()
        startPollButton.backgroundColor = .clickerBlue
        startPollButton.layer.cornerRadius = 8
        startPollButton.setTitle("Start Poll", for: .normal)
        startPollButton.setTitleColor(.white, for: .normal)
        startPollButton.titleLabel?.font = UIFont._18SemiboldFont
        startPollButton.addTarget(self, action: #selector(startPoll), for: .touchUpInside)
        addSubview(startPollButton)
        bringSubview(toFront: startPollButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        questionTextField.snp.updateConstraints{ make in
            make.size.equalTo(CGSize(width: frame.width, height: 61))
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        optionsTableView.snp.updateConstraints { make in
            make.width.equalTo(frame.width * 0.904)
            make.top.equalTo(questionTextField.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-(startPollButton.frame.height + 23))
            make.centerX.equalToSuperview()
        }
        
        startPollButton.snp.updateConstraints { make in
            make.size.equalTo(CGSize(width: optionsTableView.frame.width, height: 55))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-18)
        }
        
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func deleteOption(index: Int) {
        numOptions -= 1
        let indexSet = NSIndexSet(index: index)
        optionsTableView.deleteSections(indexSet as IndexSet, with: .fade)
        optionsTableView.reloadData()
    }
}

