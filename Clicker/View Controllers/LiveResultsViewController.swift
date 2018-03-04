//
//  LiveResultsViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 2/3/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit
import Presentr

protocol NewQuestionDelegate {
    func creatingNewQuestion()
}

class LiveResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SessionDelegate {
    
    var session: Session!
    var pollCode: String!
    var currentState: CurrentState!
    var totalNumResults: Float = 0
    var isOldPoll: Bool!
    var codeBarButtonItem: UIBarButtonItem!
    var endSessionBarButtonItem: UIBarButtonItem!
    var headerView: UIView!
    var separatorView: UIView!
    var liveResultsLabel: UILabel!
    var timerLabel: UILabel!
    var editPollButton: UIButton!
    var timer: Timer!
    var elapsedSeconds: Int = 0
    
    var questionLabel: UILabel!
    var optionResultsTableView: UITableView!
    var shareResultsButton: UIButton!
    var newQuestionButton: UIButton!
    
    var question: String!
    var options: [String]!
    
    var newQuestionDelegate: NewQuestionDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clickerBackground
        session.delegate = self
        setupNavBar()
        setupViews()
        setupConstraints()
        runTimer()
        
    }
    
    // End session
    @objc func endSession() {
        let presenter: Presentr = Presentr(presentationType: .bottomHalf)
        presenter.roundCorners = false
        presenter.dismissOnSwipe = true
        presenter.dismissOnSwipeDirection = .bottom
        let endSessionVC = EndSessionViewController()
        endSessionVC.isOldPoll = isOldPoll
        endSessionVC.dismissController = self
        endSessionVC.session = self.session
        customPresentViewController(presenter, viewController: endSessionVC, animated: true, completion: nil)
    }
    
    // Edit poll
    @objc func editPoll() {
        // Emit socket messsage to end question
        session.socket.emit("server/question/end", with: [])
        // Pop to CreateQuestionVC
        self.navigationController?.popViewController(animated: true)
    }
    
    // Share results with users
    @objc func shareResults() {
        // Emit socket message to share results to users
        session.socket.emit("server/question/results", with: [])
        // Cannot Edit Poll anymore
        editPollButton.alpha = 0
        editPollButton.isUserInteractionEnabled = false
        timer.invalidate()
    }
    
    // Create a followup question
    @objc func createNewQuestion() {
        // Emit socket messsage to end question
        session.socket.emit("server/question/end", with: [])
        // Tell delegate that we want to create a new question
        newQuestionDelegate.creatingNewQuestion()
        // Pop to CreateQuestionVC
        self.navigationController?.popViewController(animated: true)
    }
    
    // Start timer
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    // Update timer label
    @objc func updateTime() {
        elapsedSeconds += 1
        if (elapsedSeconds < 10) {
            timerLabel.text = "00:0\(elapsedSeconds)"
        } else if (elapsedSeconds < 60) {
            timerLabel.text = "00:\(elapsedSeconds)"
        } else {
            let minutes = Int(elapsedSeconds / 60)
            let seconds = elapsedSeconds - minutes * 60
            if (elapsedSeconds < 600) {
                if (seconds < 10) {
                    timerLabel.text = "0\(minutes):0\(seconds)"
                } else {
                    timerLabel.text = "0\(minutes):\(seconds)"
                }
            } else {
                if (seconds < 10) {
                    timerLabel.text = "\(minutes):0\(seconds)"
                } else {
                    timerLabel.text = "\(minutes):\(seconds)"
                }
            }
        }
    }
    
    // MARK - Tableview methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultMCOptionCellID", for: indexPath) as! ResultMCOptionCell
        cell.choiceTag = indexPath.row
        cell.optionLabel.text = options[indexPath.row]
        if let currState = currentState {
            let mcOption: String = intToMCOption(indexPath.row)
            if let numSelected = currState.results[mcOption] as? Int {
                print("nonzero width")
                cell.numberLabel.text = "\(numSelected)"
                let width = CGFloat(Float(numSelected) / totalNumResults)
                cell.highlightWidthConstraint.update(offset: width * cell.frame.width)
            } else {
                print("zero width")
                cell.numberLabel.text = "0"
                cell.highlightWidthConstraint.update(offset: 0)
            }
            UIView.animate(withDuration: 0.5, animations: {
                cell.layoutIfNeeded()
            })
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height * 0.08888888889
    }
    
    
    // MARK - Setup/layout views
    func setupViews() {
        headerView = UIView()
        headerView.backgroundColor = .clickerBackground
        view.addSubview(headerView)
        
        separatorView = UIView()
        separatorView.backgroundColor = .clickerMediumGray
        headerView.addSubview(separatorView)
        
        liveResultsLabel = UILabel()
        liveResultsLabel.text = "Live Results"
        liveResultsLabel.font = UIFont._16MediumFont
        liveResultsLabel.textColor = .clickerBlack
        liveResultsLabel.textAlignment = .center
        headerView.addSubview(liveResultsLabel)
        
        timerLabel = UILabel()
        timerLabel.text = "00:00"
        timerLabel.textColor = UIColor.clickerMediumGray
        timerLabel.font = UIFont._16MediumFont
        headerView.addSubview(timerLabel)

        editPollButton = UIButton()
        editPollButton.setTitle("Edit Poll", for: .normal)
        editPollButton.setTitleColor(.clickerBlue, for: .normal)
        editPollButton.backgroundColor = .clear
        editPollButton.addTarget(self, action: #selector(editPoll), for: .touchUpInside)
        headerView.addSubview(editPollButton)
        
        questionLabel = UILabel()
        questionLabel.text = question
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
        
        shareResultsButton = UIButton()
        shareResultsButton.backgroundColor = .clickerBackground
        shareResultsButton.titleLabel?.font = UIFont._18SemiboldFont
        shareResultsButton.setTitle("Share Results", for: .normal)
        shareResultsButton.setTitleColor(.clickerBlue, for: .normal)
        shareResultsButton.addTarget(self, action: #selector(shareResults), for: .touchUpInside)
        view.addSubview(shareResultsButton)
        
        newQuestionButton = UIButton()
        newQuestionButton.setTitle("New Question", for: .normal)
        newQuestionButton.setTitleColor(.white, for: .normal)
        newQuestionButton.titleLabel?.font = UIFont._18SemiboldFont
        newQuestionButton.backgroundColor = .clickerBlue
        newQuestionButton.layer.cornerRadius = 8
        newQuestionButton.addTarget(self, action: #selector(createNewQuestion), for: .touchUpInside)
        view.addSubview(newQuestionButton)
        view.bringSubview(toFront: newQuestionButton)
        
    }
    
    func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.frame.width, height: view.frame.height * 0.06596701649))
            make.left.equalToSuperview()
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(20)
        }
        
        separatorView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        liveResultsLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.frame.width * 0.25, height: 20))
            make.left.equalToSuperview().offset(18)
            make.centerY.equalToSuperview()
        }
        
        timerLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.frame.width * 0.15, height: 20))
            make.left.equalTo(liveResultsLabel.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        
        editPollButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.frame.width * 0.20, height: 20))
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-18)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.frame.width * 0.92, height: view.frame.height * 0.09))
            make.centerX.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(18)
        }
        
        newQuestionButton.snp.makeConstraints { make in
            make.width.equalTo(questionLabel.snp.width)
            make.height.equalTo(55)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-18)
        }
        
        shareResultsButton.snp.makeConstraints { make in
            make.width.equalTo(newQuestionButton.snp.width)
            make.height.equalTo(22)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(newQuestionButton.snp.top).offset(-24)
        }
        
        optionResultsTableView.snp.makeConstraints { make in
            make.width.equalTo(newQuestionButton.snp.width)
            make.bottom.equalTo(shareResultsButton.snp.top).offset(-8)
            make.top.equalTo(questionLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        
    }
    
    func setupNavBar() {
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
    
    // MARK: - Session methods
    func sessionConnected() {
    }
    
    func sessionDisconnected() {
    }
    
    func questionStarted(_ question: Question) {
    }
    
    func questionEnded(_ question: Question) {
    }
    
    func receivedResults(_ currentState: CurrentState) {
    }
    
    func savePoll(_ poll: Poll) {
    }
    
    func updatedTally(_ currentState: CurrentState) {
        self.currentState = currentState
        totalNumResults = 0
        for value in currentState.results.values {
            if let v = value as? Int {
                totalNumResults += Float(v)
            }
        }
        optionResultsTableView.reloadData()
    }
    
    // MARK: - Keyboard
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
