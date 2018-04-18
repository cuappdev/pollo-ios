//
//  PollBuilderViewController.swift
//  Clicker
//
//  Created by Annie Cheng on 4/18/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class PollBuilderViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, QuestionDelegate {
    
    let edgePadding: CGFloat = 18
    let topBarHeight: CGFloat = 24
    let dropdownArrowHeight: CGFloat = 5.5
    
    var dismissController: UIViewController!
    
    var exitButton: UIButton!
    var questionTypeButton: UIButton!
    var draftsButton: UIButton!
    var numDrafts: Int = 0 // TODO: use actual # of drafts
    var questionType: String!
    
    var questionCollectionView: UICollectionView!
    
     var isFollowUpQuestion: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clickerWhite
        questionType = "MULTIPLE_CHOICE"
        
        // Add Keyboard Handlers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupViews()
    }
    
    func setupViews() {
        exitButton = UIButton(frame: CGRect(x: edgePadding, y: edgePadding, width: topBarHeight, height: topBarHeight))
        exitButton.setImage(#imageLiteral(resourceName: "SmallExitIcon"), for: .normal)
        exitButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
        view.addSubview(exitButton)
        
        let questionTypeButtonWidth: CGFloat = 150
        questionTypeButton = UIButton(frame: CGRect(x: 0, y: edgePadding, width: questionTypeButtonWidth, height: topBarHeight))
        updateQuestionTypeButton()
        questionTypeButton.setTitleColor(.clickerBlack, for: .normal)
        questionTypeButton.titleLabel?.font = ._16SemiboldFont
        questionTypeButton.contentHorizontalAlignment = .center
        questionTypeButton.center.x = view.center.x
        questionTypeButton.addTarget(self, action: #selector(toggleQuestionType), for: .touchUpInside)
        questionTypeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: questionTypeButton.titleLabel!.frame.size.width)
        view.addSubview(questionTypeButton)
        
        let draftsButtonWidth: CGFloat = 100
        draftsButton = UIButton(frame: CGRect(x: view.frame.width - edgePadding - draftsButtonWidth, y: edgePadding, width: draftsButtonWidth, height: topBarHeight))
        draftsButton.setTitle("Drafts (\(numDrafts))", for: .normal)
        draftsButton.setTitleColor(.clickerBlack, for: .normal)
        draftsButton.titleLabel?.font = ._16MediumFont
        draftsButton.contentHorizontalAlignment = .right
        draftsButton.addTarget(self, action: #selector(showDrafts), for: .touchUpInside)
        view.addSubview(draftsButton)
        
        let layout = UICollectionViewFlowLayout()
        questionCollectionView = UICollectionView(frame: CGRect(x: edgePadding, y: 61.5, width: view.frame.width - edgePadding * 2, height: view.frame.height - 100), collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        questionCollectionView.alwaysBounceHorizontal = true
        questionCollectionView.delegate = self
        questionCollectionView.dataSource = self
        questionCollectionView.showsVerticalScrollIndicator = false
        questionCollectionView.showsHorizontalScrollIndicator = false
        questionCollectionView.register(MCSectionCell.self, forCellWithReuseIdentifier: "mcSectionCell")
        questionCollectionView.register(FRSectionCell.self, forCellWithReuseIdentifier: "frSectionCellID")
        questionCollectionView.backgroundColor = .clickerBackground
        questionCollectionView.isPagingEnabled = true
        view.addSubview(questionCollectionView)
    }
    
    func scrollToIndex(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        questionCollectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    func updateQuestionTypeButton() {
        let questionTypeText = (questionType == "MULTIPLE_CHOICE") ? "Multiple Choice" : "Free Response"
        questionTypeButton.setTitle(questionTypeText, for: .normal)
    }
    
    // MARK - ACTIONS
    
    // TODO: Show a dropdown of question types
    @objc func toggleQuestionType() {
        switch(questionType) {
        case "MULTIPLE_CHOICE":
            questionType = "FREE_RESPONSE"
        case "FREE_RESPONSE":
            questionType = "MULTIPLE_CHOICE"
        default:
            break
        }
        
        updateQuestionTypeButton()
        questionCollectionView.reloadData()
    }
    
    @objc func showDrafts() {
        // TODO: Show poll drafts
        print("show poll drafts")
    }
    
    @objc func exit() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - QUESTION DELEGATE
    
    func inFollowUpQuestion() {
        isFollowUpQuestion = true
    }
    
    // MARK: - COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if questionType == "MULTIPLE_CHOICE" {
            let cell = questionCollectionView.dequeueReusableCell(withReuseIdentifier: "mcSectionCell", for: indexPath) as! MCSectionCell
            cell.questionDelegate = self
            return cell
        } else if questionType == "FREE_RESPONSE" {
            let cell = questionCollectionView.dequeueReusableCell(withReuseIdentifier: "frSectionCellID", for: indexPath) as! FRSectionCell
            cell.questionDelegate = self
            return cell
        }
        
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: questionCollectionView.frame.width, height: questionCollectionView.frame.height)
    }
    
    // MARK: - KEYBOARD
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
