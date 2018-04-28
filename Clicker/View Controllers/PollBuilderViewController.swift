//
//  PollBuilderViewController.swift
//  Clicker
//
//  Created by Annie Cheng on 4/18/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import Presentr

protocol StartPollDelegate {
    func startPoll(text: String, type: String, options: [String])
}

class PollBuilderViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, QuestionDelegate, PickQTypeDelegate {
    
    let popupViewHeight: CGFloat = 95
    var pickQTypeVC: PickQTypeViewController!    
    
    let edgePadding: CGFloat = 18
    let topBarHeight: CGFloat = 24
    let dropdownArrowHeight: CGFloat = 5.5
    let buttonsViewHeight: CGFloat = 67.5
    let buttonHeight: CGFloat = 47.5
    
    var dismissController: UIViewController!
    
    var exitButton: UIButton!
    var questionTypeButton: UIButton!
    var draftsButton: UIButton!
    var numDrafts: Int = 0 // TODO: use actual # of drafts
    var questionType: String!
    
    var questionCollectionView: UICollectionView!
    let mcSectionIdentifier = "mcSectionCellID"
    let frSectionIdentifier = "frSectionCellID"
    var startPollDelegate: StartPollDelegate!
    var isFollowUpQuestion: Bool = false
    
    var buttonsView: UIView!
    var saveDraftButton: UIButton!
    var startQuestionButton: UIButton!
    
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
        questionCollectionView.register(MCSectionCell.self, forCellWithReuseIdentifier: mcSectionIdentifier)
        questionCollectionView.register(FRSectionCell.self, forCellWithReuseIdentifier: frSectionIdentifier)
        questionCollectionView.backgroundColor = .clickerBackground
        questionCollectionView.isPagingEnabled = true
        view.addSubview(questionCollectionView)
        
        buttonsView = UIView(frame: CGRect(x: 0, y: view.frame.height - buttonsViewHeight, width: view.frame.width, height: buttonsViewHeight))
        buttonsView.backgroundColor = .white
        view.addSubview(buttonsView)
        
        let divider = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1.5))
        divider.backgroundColor = .clickerBorder
        buttonsView.addSubview(divider)
        
        let buttonWidth = (view.frame.width - (edgePadding * 3)) / 2
        saveDraftButton = UIButton(frame: CGRect(x: edgePadding, y: 0, width: buttonWidth, height: buttonHeight))
        saveDraftButton.center.y = buttonsViewHeight / 2
        saveDraftButton.setTitle("Save as draft", for: .normal)
        saveDraftButton.setTitleColor(.clickerGreen, for: .normal)
        saveDraftButton.titleLabel?.font = ._16SemiboldFont
        saveDraftButton.layer.cornerRadius = buttonHeight / 2
        saveDraftButton.layer.borderColor = UIColor.clickerGreen.cgColor
        saveDraftButton.layer.borderWidth = 1.5
        saveDraftButton.addTarget(self, action: #selector(saveAsDraft), for: .touchUpInside)
        buttonsView.addSubview(saveDraftButton)
        
        startQuestionButton = UIButton(frame: CGRect(x: buttonWidth + edgePadding * 2, y: 0, width: buttonWidth, height: buttonHeight))
        startQuestionButton.center.y = buttonsViewHeight / 2
        startQuestionButton.setTitle("Start Question", for: .normal)
        startQuestionButton.setTitleColor(.white, for: .normal)
        startQuestionButton.titleLabel?.font = ._16SemiboldFont
        startQuestionButton.backgroundColor = .clickerGreen
        startQuestionButton.layer.cornerRadius = buttonHeight / 2
        startQuestionButton.addTarget(self, action: #selector(startQuestion), for: .touchUpInside)
        buttonsView.addSubview(startQuestionButton)
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
    
    @objc func saveAsDraft() {
        // TODO: Save question as draft
        print("save as draft")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func startQuestion() {
        // TODO: Start question session
        print("start question")
        let currentIndexPath = questionCollectionView.indexPathsForVisibleItems.first!
        
        // MULTIPLE CHOICE
        if (currentIndexPath.item == 0) {
            let cell = questionCollectionView.cellForItem(at: currentIndexPath) as! MCSectionCell
            let question = cell.questionTextField.text
            let options = cell.optionsDict.keys.sorted().map { cell.optionsDict[$0]! }
            print(options)
            
            startPollDelegate.startPoll(text: question!, type: "MULTIPLE_CHOICE", options: options)
        } else { // FREE RESPONSE
            let cell = questionCollectionView.cellForItem(at: currentIndexPath) as! FRSectionCell
            let question = cell.questionTextField.text
            
            startPollDelegate.startPoll(text: question!, type: "FREE_RESPONSE", options: [])
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // TODO: Show a dropdown of question types
    @objc func toggleQuestionType() {
        let width = ModalSize.full
        let height = ModalSize.custom(size: Float(popupViewHeight))
        let originY = 0
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: originY))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let presenter: Presentr = Presentr(presentationType: customType)
        presenter.transitionType = TransitionType.coverVerticalFromTop
        presenter.backgroundOpacity = 0.6
        presenter.roundCorners = false
        presenter.dismissOnSwipe = true
        presenter.dismissOnTap = true
        presenter.dismissOnSwipeDirection = .top
        presenter.backgroundOpacity = 0.4
        
        pickQTypeVC = PickQTypeViewController()
        pickQTypeVC.currentType = questionType
        pickQTypeVC.setup()
        pickQTypeVC.delegate = self
        pickQTypeVC.popupHeight = popupViewHeight
        customPresentViewController(presenter, viewController: pickQTypeVC, animated: true, completion: nil)
    }
    
    // MARK - PickQTypeDelegate
    
    func updateQuestionType(_ type: String) {
        pickQTypeVC.dismiss(animated: true, completion: nil)
        questionType = type
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
            let cell = questionCollectionView.dequeueReusableCell(withReuseIdentifier: mcSectionIdentifier, for: indexPath) as! MCSectionCell
            cell.questionTextField.becomeFirstResponder()
            cell.questionDelegate = self
            return cell
        } else if questionType == "FREE_RESPONSE" {
            let cell = questionCollectionView.dequeueReusableCell(withReuseIdentifier: frSectionIdentifier, for: indexPath) as! FRSectionCell
            cell.questionTextField.becomeFirstResponder()
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
            buttonsView.frame.origin.y = view.frame.height - keyboardSize.height - buttonsViewHeight
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            buttonsView.frame.origin.y += keyboardSize.height
        }
    }

}
