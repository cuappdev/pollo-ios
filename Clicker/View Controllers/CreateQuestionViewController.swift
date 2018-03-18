//
//  CreateQuestionViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 2/3/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import Presentr
import SnapKit

class CreateQuestionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SliderBarDelegate, QuestionDelegate {
    
    
    var session: Session!
    var pollCode: String!
    var oldPoll: Poll!
    var isFollowUpQuestion: Bool = false
    var grayViewBottomConstraint: Constraint!
    
    var codeBarButtonItem: UIBarButtonItem!
    var endSessionBarButtonItem: UIBarButtonItem!
    var questionOptionsView: QuestionOptionsView!
    var questionCollectionView: UICollectionView!
    var grayView: UIView!
    var startQuestionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Keyboard Handlers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if (oldPoll == nil) {
            createPoll()
        } else {
            self.encodeObjForKey(obj: oldPoll, key: "currentPoll")
            startCreatedPoll(poll: oldPoll)
        }
        view.backgroundColor = .clickerBackground
        setupNavBar()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = questionCollectionView.dequeueReusableCell(withReuseIdentifier: "mcSectionCell", for: indexPath) as! MCSectionCell
            cell.questionDelegate = self
            return cell
        }
        let cell = questionCollectionView.dequeueReusableCell(withReuseIdentifier: "frSectionCellID", for: indexPath) as! FRSectionCell
        cell.questionDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        questionOptionsView.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: questionCollectionView.frame.width, height: questionCollectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        questionOptionsView.sliderBarLeftConstraint.constant = scrollView.contentOffset.x / 2
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        questionOptionsView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
    
    // END SESSION
    @objc func endSession() {
        if (isFollowUpQuestion && oldPoll == nil) {
            // SHOW SAVE SESSION OPTION
            let presenter: Presentr = Presentr(presentationType: .bottomHalf)
            presenter.roundCorners = false
            presenter.dismissOnSwipe = true
            presenter.dismissOnSwipeDirection = .bottom
            let endSessionVC = EndSessionViewController()
            endSessionVC.dismissController = self
            endSessionVC.session = self.session
            customPresentViewController(presenter, viewController: endSessionVC, animated: true, completion: nil)
        } else {
            // END POLL
            if let sess = session {
                sess.socket.disconnect()
            }
            let poll = decodeObjForKey(key: "currentPoll") as! Poll
            let save = (oldPoll != nil)
            endPoll(poll: poll, save: save)
            navigationController?.popViewController(animated: true)
        }
    }
    
    // END POLL
    func endPoll(poll: Poll, save: Bool) {
        EndPoll(id: poll.id, save: save).make()
            .catch { error -> Void in
                print(error)
        }
    }
    
    // CREATE POLL
    func createPoll() {
        let pollCode = UserDefaults.standard.value(forKey: "pollCode") as! String
        CreatePoll(name: "", pollCode: pollCode).make()
            .done { poll -> Void in
                self.encodeObjForKey(obj: poll, key: "currentPoll")
                self.startCreatedPoll(poll: poll)
            }.catch { error -> Void in
                print(error)
                return
            }
    }
    
    // START CREATED POLL
    func startCreatedPoll(poll: Poll) {
        StartCreatedPoll(id: poll.id).make()
            .done { port -> Void in
                self.session = Session(id: poll.id, userType: "admin")
                // Reload collection view so that cell has correct session property
                DispatchQueue.main.async {
                    self.questionCollectionView.reloadData()
                }
            }.catch { error -> Void in
                print("error")
        }
    }
    
    // START QUESTION
    @objc func startQuestion() {
        let liveResultsVC = LiveResultsViewController()
        liveResultsVC.session = session
        liveResultsVC.pollCode = pollCode
        liveResultsVC.isOldPoll = (oldPoll != nil)
        
        let currentIndexPath = questionCollectionView.indexPathsForVisibleItems.first!
        
        // MULTIPLE CHOICE
        if (currentIndexPath.item == 0) {
            let cell = questionCollectionView.cellForItem(at: currentIndexPath) as! MCSectionCell
            let question = cell.questionTextField.text
            let options = cell.optionsDict.keys.sorted().map { cell.optionsDict[$0]! }
            liveResultsVC.question = question
            liveResultsVC.options = options
            liveResultsVC.newQuestionDelegate = cell
            
            // EMIT START QUESTION
            let socketQuestion: [String:Any] = [
                "text": question,
                "type": "MULTIPLE_CHOICE",
                "options": options
            ]
            session.socket.emit("server/question/start", with: [socketQuestion])
        } else { // FREE RESPONSE
            let cell = questionCollectionView.cellForItem(at: currentIndexPath) as! FRSectionCell
            let question = cell.questionTextField.text
            liveResultsVC.question = question
            liveResultsVC.options = []
            liveResultsVC.newQuestionDelegate = cell
            
            // EMIT START QUESTION
            let socketQuestion: [String:Any] = [
                "text": question,
                "type": "FREE_RESPONSE",
                "options": []
            ]
            session.socket.emit("server/question/start", with: [socketQuestion])
        }
        
        navigationController?.pushViewController(liveResultsVC, animated: true)
    }
    
    // MARK: - DELEGATES
    
    func inFollowUpQuestion() {
        isFollowUpQuestion = true
    }
    
    func scrollToIndex(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        questionCollectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    // MARK: - SETUP VIEWS
    func setupViews() {
        questionOptionsView = QuestionOptionsView(frame: .zero, options: ["Multiple Choice", "Free Response"], sliderBarDelegate: self)
        view.addSubview(questionOptionsView)
        
        let layout = UICollectionViewFlowLayout()
        questionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        
        grayView = UIView()
        grayView.backgroundColor = .clickerBackground
        view.addSubview(grayView)
        view.bringSubview(toFront: grayView)
        
        startQuestionButton = UIButton()
        startQuestionButton.backgroundColor = .clickerBlue
        startQuestionButton.layer.cornerRadius = 8
        startQuestionButton.setTitle("Start Question", for: .normal)
        startQuestionButton.setTitleColor(.white, for: .normal)
        startQuestionButton.titleLabel?.font = UIFont._18SemiboldFont
        startQuestionButton.addTarget(self, action: #selector(startQuestion), for: .touchUpInside)
        grayView.addSubview(startQuestionButton)
    }
    
    func setupConstraints() {
        questionOptionsView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.frame.width, height: view.frame.height * 0.06596701649))
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(20)
            make.left.equalToSuperview()
        }
        
        questionCollectionView.snp.updateConstraints { make in
            make.width.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalTo(questionOptionsView.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.63)
        }
        
        grayView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(92)
            make.centerX.equalToSuperview()
            if #available(iOS 11.0, *) {
                self.grayViewBottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).constraint
            } else {
                self.grayViewBottomConstraint = make.bottom.equalTo(bottomLayoutGuide.snp.top).constraint
            }
        }
        
        startQuestionButton.snp.updateConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(55)
            make.center.equalToSuperview()
        }
        
    }

    func setupNavBar() {
        UINavigationBar.appearance().barTintColor = .clickerGreen
        
        let codeLabel = UILabel()
        if let code = pollCode {
            let codeAttributedString = NSMutableAttributedString(string: "SESSION CODE: \(code)")
            codeAttributedString.addAttribute(.font, value: UIFont._16RegularFont, range: NSRange(location: 0, length: 13))
            codeAttributedString.addAttribute(.font, value: UIFont._16MediumFont, range: NSRange(location: 13, length: codeAttributedString.length - 13))
            codeLabel.attributedText = codeAttributedString
        }
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
    
    // MARK: - KEYBOARD
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.keyWindow
                let safeBottomPadding = window?.safeAreaInsets.bottom
                grayViewBottomConstraint.update(offset: safeBottomPadding! - keyboardSize.height)
            } else {
                grayViewBottomConstraint.update(offset: -keyboardSize.height)
            }
            view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            grayViewBottomConstraint.update(offset: 0)
            view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
