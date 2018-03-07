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

class CreateQuestionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SliderBarDelegate, StartQuestionDelegate, FollowUpQuestionDelegate {
    
    var session: Session!
    var pollCode: String!
    var oldPoll: Poll!
    var codeBarButtonItem: UIBarButtonItem!
    var endSessionBarButtonItem: UIBarButtonItem!
    var questionOptionsView: QuestionOptionsView!
    var questionCollectionView: UICollectionView!
    
    var isFollowUpQuestion: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clickerBackground
        
        if (oldPoll == nil) {
            createPoll()
        } else {
            self.encodeObjForKey(obj: oldPoll, key: "currentPoll")
            startCreatedPoll(poll: oldPoll)
        }
        setupNavBar()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Collection view methods
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = questionCollectionView.dequeueReusableCell(withReuseIdentifier: "mcSectionCell", for: indexPath) as! MCSectionCell
            cell.startQuestionDelegate = self
            cell.followUpQuestionDelegate = self
            return cell
        }
        let cell = questionCollectionView.dequeueReusableCell(withReuseIdentifier: "frSectionCellID", for: indexPath) as! FRSectionCell
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
    
    // End current session
    @objc func endSession() {
        // Allow admin to save session if this is follow-up question
        if (isFollowUpQuestion) {
            let presenter: Presentr = Presentr(presentationType: .bottomHalf)
            presenter.roundCorners = false
            presenter.dismissOnSwipe = true
            presenter.dismissOnSwipeDirection = .bottom
            let endSessionVC = EndSessionViewController()
            endSessionVC.dismissController = self
            endSessionVC.session = self.session
            customPresentViewController(presenter, viewController: endSessionVC, animated: true, completion: nil)
            return
        }
        // End poll/Disconnect socket
        if let sess = session {
           sess.socket.disconnect()
        }
        let poll = decodeObjForKey(key: "currentPoll") as! Poll
        EndPoll(id: poll.id, save: false).make()
            .catch { error -> Void in
                print(error)
            }
        navigationController?.popToRootViewController(animated: true)
    }
    
    // Create a poll
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
    
    // Start a created poll
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
    
    // MARK: - DELEGATES
    
    func startQuestion(question: String, options: [String], newQuestionDelegate: NewQuestionDelegate) {
        let liveResultsVC = LiveResultsViewController()
        
        //Pass values to LiveResultsVC
        liveResultsVC.question = question
        liveResultsVC.options = options
        liveResultsVC.session = session
        liveResultsVC.pollCode = pollCode
        liveResultsVC.newQuestionDelegate = newQuestionDelegate
        
        // Emit socket messsage to start question
        let question: [String:Any] = [
            "text": question,
            "type": "MULTIPLE_CHOICE",
            "options": options
        ]
        session.socket.emit("server/question/start", with: [question])
        
        navigationController?.pushViewController(liveResultsVC, animated: true)
    }
    
    func inFollowUpQuestion() {
        isFollowUpQuestion = true
    }
    
    func scrollToIndex(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        questionCollectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    // MARK: - SLIDERVIEW
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        questionOptionsView.sliderBarLeftConstraint.constant = scrollView.contentOffset.x / 2
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        questionOptionsView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
    
    // MARK: - Setup/layout views
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
            make.bottom.equalToSuperview()
            make.top.equalTo(questionOptionsView.snp.bottom)
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
    
    // MARK: - Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
