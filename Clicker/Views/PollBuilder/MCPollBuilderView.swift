//
//  MCPollBuilderView.swift
//  Clicker
//
//  Created by eoin on 4/28/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class MCPollBuilderView: UIView, UITableViewDelegate, UITableViewDataSource, MultipleChoiceOptionDelegate, UITextFieldDelegate {
    
    var pollBuilderDelegate: PollBuilderDelegate!
    var editable: Bool!
    
    var questionDelegate: QuestionDelegate!
    var session: Session!
    var grayViewBottomConstraint: Constraint!
    var optionsDict: [Int:String] = [Int:String]()
    var numOptions: Int = 2
    
    var questionTextField: UITextField!
    var optionsTableView: UITableView!
    
    // MARK: - INITIALIZATION
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Add Keyboard Handlers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        clearOptionsDict()
        setupViews()
        layoutSubviews()
        editable = false
    }
    
    // MARK: - POLLING
    func clearOptionsDict() {
        optionsDict.removeAll()
        for i in 0...numOptions - 1 {
            optionsDict[i] = ""
        }
    }
    
    // MARK: - TABLEVIEW
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == numOptions && numOptions <= 25) {
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
        if (indexPath.row == numOptions && numOptions <= 25) {
            numOptions += 1
            optionsDict[numOptions - 1] = ""
            if (numOptions < 26) {
                tableView.beginUpdates()
                tableView.insertRows(at: [indexPath], with: .none)
                tableView.reloadData()
                tableView.endUpdates()
                let bottomIndexPath: IndexPath
                bottomIndexPath = IndexPath(item: indexPath.item + 1, section: 0)
                tableView.scrollToRow(at: bottomIndexPath, at: .bottom, animated: false)
            } else {
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (numOptions <= 25) {
            return numOptions + 1
        }
        return numOptions
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        questionTextField = UITextField()
        questionTextField.attributedPlaceholder = NSAttributedString(string: "Ask a question...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.clickerMediumGray, NSAttributedStringKey.font: UIFont._18RegularFont])
        questionTextField.font = ._18RegularFont
        questionTextField.returnKeyType = .done
        questionTextField.delegate = self
        questionTextField.addTarget(self, action: #selector(updateEditable), for: .allEditingEvents)
        addSubview(questionTextField)
        
        optionsTableView = UITableView()
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        optionsTableView.register(CreateMCOptionCell.self, forCellReuseIdentifier: "createMCOptionCellID")
        optionsTableView.register(AddMoreOptionCell.self, forCellReuseIdentifier: "addMoreOptionCellID")
        optionsTableView.backgroundColor = .clickerWhite
        optionsTableView.clipsToBounds = true
        optionsTableView.separatorStyle = .none
        
        addSubview(optionsTableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        questionTextField.snp.updateConstraints{ make in
            make.size.equalTo(CGSize(width: frame.width, height: 48))
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        optionsTableView.snp.updateConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(questionTextField.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - MC OPTION DELEGATE
    
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
    
    @objc func updateEditable() {
        if editable {
            if questionTextField.text == "" {
                pollBuilderDelegate.updateDrafts(false)
                editable = false
            }
        } else {
            if questionTextField.text != "" {
                pollBuilderDelegate.updateDrafts(true)
                editable = true
            }
        }
    }
    
    // MARK: - KEYBOARD
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets:UIEdgeInsets!
            if UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation) {
                contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height - 6), 0.0)
            } else {
                contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0)
            }
            self.optionsTableView.contentInset = contentInsets;
            self.optionsTableView.scrollIndicatorInsets = contentInsets;
            layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.optionsTableView.contentInset = UIEdgeInsets.zero;
            self.optionsTableView.scrollIndicatorInsets = UIEdgeInsets.zero;
            layoutIfNeeded()
        }
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
