//
//  LiveResultsViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 2/3/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
import Presentr

protocol NewQuestionDelegate {
    func creatingNewQuestion()
}

class LiveResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SessionDelegate {
    
    var session: Session!
    var pollCode: String!
    var isOldPoll: Bool!
    var currentState: CurrentState!
    var totalNumResults: Float = 0
    var timer: Timer!
    var elapsedSeconds: Int = 0
    var endedQuestion: Bool = false
    
    var codeBarButtonItem: UIBarButtonItem!
    var endSessionBarButtonItem: UIBarButtonItem!
    var headerView: UIView!
    var separatorView: UIView!
    var liveResultsLabel: UILabel!
    var timerLabel: UILabel!
    var editPollButton: UIButton!
    
    var questionLabel: UILabel!
    var resultsTableView: UITableView!
    var shareResultsButton: UIButton!
    var questionButton: UIButton!
    
    var question: String!
    var options: [String]!
    var freeResponses: [String] = [String]()
    var isMCQuestion: Bool!
    
    var newQuestionDelegate: NewQuestionDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clickerBackground
        session.delegate = self
        isMCQuestion = (options.count > 0)
        
        setupNavBar()
        setupViews()
        setupConstraints()
        runTimer()
    }
    
    // End session
    @objc func endSession() {
        if (!isOldPoll) {
            let presenter: Presentr = Presentr(presentationType: .bottomHalf)
            presenter.roundCorners = false
            presenter.dismissOnSwipe = true
            presenter.dismissOnSwipeDirection = .bottom
            let endSessionVC = EndSessionViewController()
            endSessionVC.dismissController = self
            endSessionVC.session = self.session
            customPresentViewController(presenter, viewController: endSessionVC, animated: true, completion: nil)
        } else {
            // END QUESTION
            session.socket.emit("server/question/end", with: [])
            
            let currentPoll = decodeObjForKey(key: "currentPoll") as! Poll
            endPoll(pollId: currentPoll.id, save: true)
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func endPoll(pollId: Int, save: Bool) {
        EndPoll(id: pollId, save: save).make()
            .done { Void -> Void in
                // DISCONNECT SOCKET
                self.session.socket.disconnect()
            }.catch { error -> Void in
                print(error)
        }
    }
    
    // EDIT POLL
    @objc func editPoll() {
        // END QUESTION
        session.socket.emit("server/question/end", with: [])
        // POP TO CREATE QUESTION VC
        self.navigationController?.popViewController(animated: true)
    }
    
    // SHARE RESULTS TO USERS
    @objc func shareResults() {
        session.socket.emit("server/question/results", with: [])
        // UPDATE VIEWS
        shareResultsButton.alpha = 0
        shareResultsButton.isUserInteractionEnabled = false
        timer.invalidate()
    }
    
    // EITHER END QUESTION / START NEW QUESTION
    @objc func questionBtnClicked() {
        if (endedQuestion) {
            // START NEW QUESTION
            
            // Tell delegate that we want to create a new question
            newQuestionDelegate.creatingNewQuestion()
            // Pop to CreateQuestionVC
            self.navigationController?.popViewController(animated: true)
        } else {
            // END QUESTION
            
            session.socket.emit("server/question/end", with: [])
            
            questionButton.setTitle("New Question", for: .normal)
            shareResultsButton.alpha = 1
            shareResultsButton.isUserInteractionEnabled = true
            editPollButton.alpha = 0
            editPollButton.isUserInteractionEnabled = false
            liveResultsLabel.text = "Final Results"
            timer.invalidate()
            endedQuestion = true
        }
    }
    
    // START TIMER
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    // UPDATE TIMER LABEL
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
    
    // MARK - TABLEVIEW
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (isMCQuestion) { // MULTIPLE CHOICE
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultMCCellID", for: indexPath) as! ResultMCCell
            cell.choiceTag = indexPath.row
            cell.optionLabel.text = options[indexPath.row]
            cell.selectionStyle = .none
            
            guard let currState = currentState else {
                return cell
            }
            
            // UPDATE HIGHLIGHT VIEW WIDTH
            let mcOption: String = intToMCOption(indexPath.row)
            guard let info = currState.results[mcOption] as? [String:Any], let count = info["count"] as? Int else {
                return cell
            }
            cell.numberLabel.text = "\(count)"
            if (totalNumResults > 0) {
                let percentWidth = CGFloat(Float(count) / totalNumResults)
                let totalWidth = cell.frame.width - 36
                cell.highlightWidthConstraint.update(offset: percentWidth * totalWidth)
            } else {
                cell.highlightWidthConstraint.update(offset: 0)
            }
            
            // ANIMATE CHANGE
            UIView.animate(withDuration: 0.5, animations: {
                cell.layoutIfNeeded()
            })
            return cell
            
        } else { // FREE RESPONSE
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultFRCellID", for: indexPath) as! ResultFRCell
            cell.freeResponseLabel.text = freeResponses[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isMCQuestion) { // MULTIPLE CHOICE
            return options.count
        } else { // FREE RESPONSE
            return freeResponses.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (isMCQuestion) {
            return view.frame.height * 0.089
        } else {
            // CALCULATE CELL HEIGHT FOR FR
            let text = freeResponses[indexPath.row]
            let frameForMessage = NSString(string: text).boundingRect(with: CGSize(width: view.frame.width, height: 2000) , options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSAttributedStringKey.font: UIFont._16RegularFont], context: nil)
            let height = frameForMessage.height + 40
            return height
        }
    }
    
    // MARK: - SESSION
    func sessionConnected() {}
    func sessionDisconnected() {}
    func questionStarted(_ question: Question) {}
    func questionEnded(_ question: Question) {}
    func receivedResults(_ currentState: CurrentState) {}
    func savePoll(_ poll: Poll) {}
    
    func updatedTally(_ currentState: CurrentState) {
        self.currentState = currentState
        totalNumResults = Float(currentState.getTotalCount()) // FOR MC QUESTIONS
        freeResponses = currentState.getResponses()
        resultsTableView.reloadData()
    }
    
    // MARK - LAYOUT
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
        editPollButton.titleLabel?.font = UIFont._16MediumFont
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
        
        resultsTableView = UITableView()
        resultsTableView.backgroundColor = .clear
        resultsTableView.separatorStyle = .none
        resultsTableView.showsVerticalScrollIndicator = false
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.clipsToBounds = true
        resultsTableView.register(ResultMCCell.self, forCellReuseIdentifier: "resultMCCellID")
        resultsTableView.register(ResultFRCell.self, forCellReuseIdentifier: "resultFRCellID")
        view.addSubview(resultsTableView)
        
        shareResultsButton = UIButton()
        shareResultsButton.backgroundColor = .clickerBackground
        shareResultsButton.titleLabel?.font = UIFont._18SemiboldFont
        shareResultsButton.setTitle("Share Results", for: .normal)
        shareResultsButton.setTitleColor(.clickerBlue, for: .normal)
        shareResultsButton.addTarget(self, action: #selector(shareResults), for: .touchUpInside)
        shareResultsButton.alpha = 0
        shareResultsButton.isUserInteractionEnabled = false
        view.addSubview(shareResultsButton)
        
        questionButton = UIButton()
        questionButton.setTitle("End Question", for: .normal)
        questionButton.setTitleColor(.white, for: .normal)
        questionButton.titleLabel?.font = UIFont._18SemiboldFont
        questionButton.backgroundColor = .clickerBlue
        questionButton.layer.cornerRadius = 8
        questionButton.addTarget(self, action: #selector(questionBtnClicked), for: .touchUpInside)
        view.addSubview(questionButton)
        view.bringSubview(toFront: questionButton)
        
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
        
        questionButton.snp.makeConstraints { make in
            make.width.equalTo(questionLabel.snp.width)
            make.height.equalTo(55)
            make.centerX.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-18)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-18)
            }
        }
        
        shareResultsButton.snp.makeConstraints { make in
            make.width.equalTo(questionButton.snp.width)
            make.height.equalTo(22)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(questionButton.snp.top).offset(-24)
        }
        
        resultsTableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalTo(shareResultsButton.snp.top).offset(-16)
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
    
    // MARK: - KEYBOARD
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
