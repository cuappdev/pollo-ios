//
//  HomeViewController.swift
//  Clicker
//
//  Created by Keivan Shahida on 9/24/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Neutron
import Crashlytics

class HomeViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, JoinSessionCellDelegate {
    
    var whiteView: UIView!
    var bottomView: UIView!
    var createSessionButton: UIButton!
    var homeTableView: UITableView!
    var refreshControl: UIRefreshControl!
    var livePolls: [Poll] = [Poll]()
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .clickerBackground
        lookForLivePolls()
        setupViews()
        setupConstraints()
        
        let appDelegate = AppDelegate()
        let significantEvents : Int = UserDefaults.standard.integer(forKey: "significantEvents")
        if significantEvents > 20 {
            appDelegate.requestReview()
            UserDefaults.standard.set(0, forKey:"significantEvents")
        }
        
    }
    
    // MARK: - KEYBOARD
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - TABLEVIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "liveSessionCellID", for: indexPath) as! LiveSessionCell
            let livePoll = livePolls[indexPath.row]
            cell.sessionLabel.text = livePoll.name
            cell.codeLabel.text = "Session Code: \(livePoll.code)"
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "joinSessionCellID", for: indexPath) as! JoinSessionCell
            cell.joinSessionCellDelegate = self
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "savedSessionCellID", for: indexPath) as! SavedSessionCell
            let polls = decodeObjForKey(key: "adminSavedPolls") as! [Poll]
            let poll = polls[indexPath.row]
            cell.sessionLabel.text = poll.name
            cell.codeLabel.text = "Session Code: \(poll.code)"
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return livePolls.count
        case 1:
            return 1
        case 2:
            if (UserDefaults.standard.value(forKey: "adminSavedPolls") == nil) {
                return 0
            }
            let pollsData = UserDefaults.standard.value(forKey: "adminSavedPolls") as! Data
            let polls = NSKeyedUnarchiver.unarchiveObject(with: pollsData) as! [Poll]
            return polls.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let livePoll = livePolls[indexPath.row]
            let liveSessionVC = LiveSessionViewController()
            liveSessionVC.poll = livePoll
            self.navigationController?.pushViewController(liveSessionVC, animated: true)
        case 1:
            print("case 1")
        case 2:
            let polls = decodeObjForKey(key: "adminSavedPolls") as! [Poll]
            let selectedPoll = polls[indexPath.row]
            UserDefaults.standard.set(selectedPoll.code, forKey: "pollCode")
            let createQuestionVC = CreateQuestionViewController()
            createQuestionVC.pollCode = selectedPoll.code
            createQuestionVC.oldPoll = polls[indexPath.row]
            self.navigationController?.pushViewController(createQuestionVC, animated: true)
        default:
            print("default")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 76
        case 1:
            return 100
        case 2:
            return 80
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sessionHeaderID") as! SessionHeader
        switch section {
        case 0:
            headerView.title = "Live Sessions"
        case 1:
            headerView.title = "Join A Session"
        case 2:
            headerView.title = "Saved Sessions"
        default:
            headerView.title = ""
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return (livePolls.count == 0) ? 0 : 40
        case 1:
            return 40
        case 2:
            if let pollsData = UserDefaults.standard.value(forKey: "adminSavedPolls") as? Data {
                let polls = NSKeyedUnarchiver.unarchiveObject(with: pollsData) as! [Poll]
                return (polls.count == 0) ? 0 : 40
            }
            return 0
        default:
            return 0
        }
    }
    
    // MARK: - SESSIONS / POLLS
    
    // Refresh control was pulled
    @objc func refreshPulled() {
        lookForLivePolls()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
    
    // Get current live, subscribed polls
    func lookForLivePolls() {
        if (UserDefaults.standard.value(forKey: "userSavedPolls") == nil) {
            print("no user saved polls")
            return
        }
        let polls = decodeObjForKey(key: "userSavedPolls") as! [Poll]
        let codes: [String] = polls.map {
            $0.code
        }
        
        GetLivePolls(pollCodes: codes).make()
            .done { polls in
                // Reload tableview with updatedLivePolls
                self.livePolls = polls
                DispatchQueue.main.async {
                    self.homeTableView.reloadData()
                }
            }.catch { error -> Void in
                let alert = self.createAlert(title: "Error", message: "No live session detected for code entered.")
                self.present(alert, animated: true, completion: nil)
                print(error)
        }
    }
    
    // Generate poll code
    func getNewPollCode(completion: @escaping ((String) -> Void)) {
        GeneratePollCode().make()
            .done { code -> Void in
                UserDefaults.standard.setValue(code, forKey: "pollCode")
                completion(code)
            }.catch { error -> Void in
                let alert = self.createAlert(title: "Error", message: "Error generating new poll code.")
                self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Create New Poll
    @objc func createNewPoll() {
        // Generate poll code if none exists
        getNewPollCode { code in
            // Push CreateQuestionVC
            let createQuestionVC = CreateQuestionViewController()
            createQuestionVC.pollCode = code
            self.navigationController?.pushViewController(createQuestionVC, animated: true)
            // Log significant event
            Answers.logCustomEvent(withName: "Created New Poll", customAttributes: nil)
            let significantEvents : Int = UserDefaults.standard.integer(forKey: "significantEvents")
            UserDefaults.standard.set(significantEvents + 5, forKey:"significantEvents")
        }
    }
    
    // Returns whether there are any admin saved polls
    func savedPollsExist() -> Bool {
        if let adminSavedPolls = UserDefaults.standard.value(forKey: "adminSavedPolls") {
            let pollsData = adminSavedPolls as! Data
            let polls = NSKeyedUnarchiver.unarchiveObject(with: pollsData) as! [Poll]
            return (polls.count >= 1)
        }
        return false
    }
    
    // Join a session with the code entered
    func joinSession(with code: String) {
        // Clear textfield input
        GetLivePolls(pollCodes: [code]).make()
            .done { polls in
                guard let poll = polls.first else {
                    let alert = self.createAlert(title: "Error", message: "No live session detected for code entered.")
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                let liveSessionVC = LiveSessionViewController()
                liveSessionVC.poll = poll
                self.view.endEditing(true)
                self.navigationController?.pushViewController(liveSessionVC, animated: true)
                // Log significant event
                Answers.logCustomEvent(withName: "Joined Poll", customAttributes: nil)
                let significantEvents : Int = UserDefaults.standard.integer(forKey: "significantEvents")
                UserDefaults.standard.set(significantEvents + 1, forKey:"significantEvents")
            }.catch { error -> Void in
                let alert = self.createAlert(title: "Error", message: "No live session detected for code entered.")
                self.present(alert, animated: true, completion: nil)
                print(error)
        }
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        
        //CREATE POLL
        whiteView = UIView()
        whiteView.backgroundColor = .white
        view.addSubview(whiteView)
        
        bottomView = UIView()
        bottomView.backgroundColor = .white
        view.addSubview(bottomView)
        
        createSessionButton = UIButton()
        createSessionButton.setTitle("Create New Session", for: .normal)
        createSessionButton.setTitleColor(.white, for: .normal)
        createSessionButton.titleLabel?.font = UIFont._18MediumFont
        createSessionButton.backgroundColor = .clickerGreen
        createSessionButton.layer.cornerRadius = 8
        createSessionButton.addTarget(self, action: #selector(createNewPoll), for: .touchUpInside)
        whiteView.addSubview(createSessionButton)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        
        homeTableView = UITableView(frame: .zero, style: .grouped)
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.separatorStyle = .none
        homeTableView.clipsToBounds = true
        homeTableView.backgroundColor = .clear
        homeTableView.tableHeaderView?.backgroundColor = .clear
        homeTableView.refreshControl = refreshControl
        
        homeTableView.register(LiveSessionCell.self, forCellReuseIdentifier: "liveSessionCellID")
        homeTableView.register(JoinSessionCell.self, forCellReuseIdentifier: "joinSessionCellID")
        homeTableView.register(SessionHeader.self, forHeaderFooterViewReuseIdentifier: "sessionHeaderID")
        homeTableView.register(SavedSessionCell.self, forCellReuseIdentifier: "savedSessionCellID")
        
        
        view.addSubview(homeTableView)
    }
    
    func setupConstraints() {
        
        whiteView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(91)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
        
        bottomView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(whiteView.snp.bottom)
        }
        
        createSessionButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.frame.width * 0.90, height: 55))
            make.center.equalToSuperview()
        }
        
        homeTableView.snp.updateConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(whiteView.snp.top)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Update live polls
        lookForLivePolls()
        
        // Hide navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // Reload TableViews
        homeTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show navigation bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
