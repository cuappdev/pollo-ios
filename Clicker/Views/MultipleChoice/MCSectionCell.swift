//
//  MCSectionCell.swift
//  Clicker
//
//  Created by Kevin Chan on 2/22/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import SnapKit
import UIKit

class MCSectionCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MultipleChoiceOptionDelegate {
    
    var createQuestionVC: CreateQuestionViewController!
    var session: Session!
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
            let indexPath = IndexPath(row: index, section: 0)
            let optionCell = optionsTableView.cellForRow(at: indexPath) as! CreateMCOptionCell
            options.append(optionCell.addOptionTextField.text!)
        }
        liveResultsVC.options = options
        liveResultsVC.session = self.session
        liveResultsVC.isOldPoll = (createQuestionVC.oldPoll != nil)
        
        // Emit socket messsage to start question
        let question: [String:Any] = [
            "text": questionTextField.text,
            "type": "MULTIPLE_CHOICE",
            "options": options
        ]
        session.socket.emit("server/question/start", with: [question])
        
        createQuestionVC.navigationController?.pushViewController(liveResultsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == numOptions) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addMoreOptionCellID") as! AddMoreOptionCell
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "createMCOptionCellID") as! CreateMCOptionCell
        cell.choiceTag = indexPath.row
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
        if (indexPath.row == numOptions) {
            numOptions += 1
            tableView.insertRows(at: [indexPath], with: .none)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numOptions + 1 // 1 extra for the "Add More" cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return frame.height * 0.1049618321
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
        optionsTableView.register(CreateMCOptionCell.self, forCellReuseIdentifier: "createMCOptionCellID")
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
        let indexPath = IndexPath(row: index, section: 0)
        optionsTableView.deleteRows(at: [indexPath], with: .fade)
        optionsTableView.reloadData()
    }
}


