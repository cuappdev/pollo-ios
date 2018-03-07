//
//  MCSectionCell.swift
//  Clicker
//
//  Created by Kevin Chan on 2/22/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import SnapKit
import UIKit

protocol StartQuestionDelegate {
    func startQuestion(question: String, options: [String], newQuestionDelegate: NewQuestionDelegate)
}

protocol FollowUpQuestionDelegate {
    func inFollowUpQuestion()
}

class MCSectionCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MultipleChoiceOptionDelegate, NewQuestionDelegate {
    
    var startQuestionDelegate: StartQuestionDelegate!
    var followUpQuestionDelegate: FollowUpQuestionDelegate!
    var session: Session!
    var questionTextField: UITextField!
    var optionsTableView: UITableView!
    var startQuestionButton: UIButton!
    var grayView: UIView!
    var grayViewBottomConstraint: Constraint!
    var optionsDict: [Int:String] = [Int:String]()
    var numOptions: Int = 2
    
    //MARK: - INITIALIZATION
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Add Keyboard Handlers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        backgroundColor = .clickerBackground
        
        clearOptionsDict()
        setupViews()
        layoutSubviews()
    }
    
    //MARK: - POLLING
    @objc func startPoll() {
        let keys = optionsDict.keys.sorted()
        let options: [String] = keys.map { optionsDict[$0]! }
        if let question = questionTextField.text {
            startQuestionDelegate.startQuestion(question: question, options: options, newQuestionDelegate: self)
        } else {
            startQuestionDelegate.startQuestion(question: "", options: options, newQuestionDelegate: self)
        }
    }
    
    func clearOptionsDict() {
        optionsDict.removeAll()
        for i in 0...numOptions - 1 {
            optionsDict[i] = ""
        }
    }
    
    //MARK: - TABLEVIEW
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == numOptions) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addMoreOptionCellID") as! AddMoreOptionCell
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "createMCOptionCellID") as! CreateMCOptionCell
        cell.choiceTag = indexPath.row
        cell.mcOptionDelegate = self
        cell.addOptionTextField.text = optionsDict[indexPath.row]
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
            optionsDict[numOptions - 1] = ""
            tableView.beginUpdates()
            tableView.insertRows(at: [indexPath], with: .none)
            tableView.reloadData()
            tableView.endUpdates()
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numOptions + 1 // 1 extra for the "Add More" cell plus 5 empty cells
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return frame.height * 0.1049618321
    }
    
    //MARK: - LAYOUT
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
        
        grayView = UIView()
        grayView.backgroundColor = .clickerBackground
        addSubview(grayView)
        bringSubview(toFront: grayView)
        
        startQuestionButton = UIButton()
        startQuestionButton.backgroundColor = .clickerBlue
        startQuestionButton.layer.cornerRadius = 8
        startQuestionButton.setTitle("Start Question", for: .normal)
        startQuestionButton.setTitleColor(.white, for: .normal)
        startQuestionButton.titleLabel?.font = UIFont._18SemiboldFont
        startQuestionButton.addTarget(self, action: #selector(startPoll), for: .touchUpInside)
        grayView.addSubview(startQuestionButton)
        
        grayView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(91)
            make.centerX.equalToSuperview()
            self.grayViewBottomConstraint = make.bottom.equalTo(0).constraint
        }
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        questionTextField.snp.updateConstraints{ make in
            make.size.equalTo(CGSize(width: frame.width, height: 61))
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        optionsTableView.snp.updateConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.90)
            make.top.equalTo(questionTextField.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-(startQuestionButton.frame.height + 23))
            make.centerX.equalToSuperview()
        }
        
        startQuestionButton.snp.updateConstraints { make in
            make.size.equalTo(CGSize(width: optionsTableView.frame.width, height: 55))
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - MCOptionDelegate
    
    func deleteOption(index: Int) {
        numOptions -= 1
        let indexPath = IndexPath(row: index, section: 0)
        optionsDict.removeValue(forKey: index)
        for (key, value) in optionsDict {
            if (key > index) {
                optionsDict.removeValue(forKey: key)
                optionsDict[key - 1] = value
            }
        }
        let deleteCell = optionsTableView.cellForRow(at: indexPath) as! CreateMCOptionCell
        deleteCell.addOptionTextField.text = ""
        optionsTableView.beginUpdates()
        optionsTableView.deleteRows(at: [indexPath], with: .fade)
        optionsTableView.reloadData()
        optionsTableView.endUpdates()
        
    }
    
    func updatedTextField(index: Int, text: String) {
        optionsDict[index] = text
    }
    
    // MARK: - NewQuestionDelegate
    
    func creatingNewQuestion() {
        // Notify that we are in a Follow Up question
        followUpQuestionDelegate.inFollowUpQuestion()
        questionTextField.text = ""
        clearOptionsDict()
        optionsTableView.reloadData()
    }
    
    // MARK: - KEYBOARD
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets:UIEdgeInsets!
            if UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)
            {
                contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height + 12), 0.0)
            }
            else
            {
                contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0)
            }
            self.optionsTableView.contentInset = contentInsets;
            self.optionsTableView.scrollIndicatorInsets = contentInsets;
            
            grayViewBottomConstraint.update(offset: -keyboardSize.height)
            layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.optionsTableView.contentInset = UIEdgeInsets.zero;
            self.optionsTableView.scrollIndicatorInsets = UIEdgeInsets.zero;
            //pollButtonBottomConstraint.update(offset: -18)
            grayViewBottomConstraint.update(offset: 0)
            layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}


