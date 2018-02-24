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

class HomeViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, JoinSessionCellDelegate {
    
    var whiteView: UIView!
    var createPollButton: UIButton!
    var homeTableView: UITableView!
    var refreshControl: UIRefreshControl!
    var livePolls: [Poll] = [Poll]()
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UserDefaults.standard.set(nil, forKey: "adminSavedPolls")
        view.backgroundColor = .clickerBackground
        lookForLivePolls()
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        
        //CREATE POLL
        whiteView = UIView()
        whiteView.backgroundColor = .white
        view.addSubview(whiteView)
        
        createPollButton = UIButton()
        createPollButton.setTitle("Create New Poll", for: .normal)
        createPollButton.setTitleColor(.white, for: .normal)
        createPollButton.titleLabel?.font = UIFont._18MediumFont
        createPollButton.backgroundColor = .clickerGreen
        createPollButton.layer.cornerRadius = 8
        createPollButton.addTarget(self, action: #selector(createNewPoll), for: .touchUpInside)
        whiteView.addSubview(createPollButton)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        
        //SAVED SESSIONS
        homeTableView = UITableView()
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
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(view.frame.height * 0.1364317841)
        }
        
        createPollButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: view.frame.width * 0.904, height: view.frame.height * 0.08245877061))
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
        // Get new poll code if needed
        getNewPollCode()
        // Reload TableViews
        homeTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show navigation bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "joinSessionCellID", for: indexPath) as! JoinSessionCell
            cell.joinSessionCellDelegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "savedSessionCellID", for: indexPath) as! SavedSessionCell
            let polls = decodeObjForKey(key: "adminSavedPolls") as! [Poll]
            let poll = polls[indexPath.row]
            cell.sessionLabel.text = poll.name
            cell.codeLabel.text = "Session Code: \(poll.code)"            
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
            let polls = decodeObjForKey(key: "userSavedPolls") as! [Poll]
            let selectedPoll = polls[indexPath.row]
            let liveSessionVC = LiveSessionViewController()
            liveSessionVC.poll = selectedPoll
            self.navigationController?.pushViewController(liveSessionVC, animated: true)
        case 1:
            print("case 1")
        case 2:
            let polls = decodeObjForKey(key: "adminSavedPolls") as! [Poll]
            let selectedPoll = polls[indexPath.row]
            UserDefaults.standard.set(selectedPoll.code, forKey: "pollCode")
            let createQuestionVC = CreateQuestionViewController()
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
        return 40
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
            return
        }
        let polls = decodeObjForKey(key: "userSavedPolls") as! [Poll]
        let codes: [String] = polls.map {
            $0.code
        }
        let parameters: Parameters = [
            "codes": codes
        ]
        requestJSON(route: "http://localhost:3000/api/v1/polls/live/", method: .post, parameters: parameters, completion: { json in
            var updatedLivePolls = [Poll]()
            if let data = json["data"] as? [[String:Any]] {
                if (data.count == 0) {
                    print("no live polls")
                    self.livePolls = updatedLivePolls
                } else {
                    print("live polls exist")
                    let nodes: [[String:Any]] = data.map {
                        $0["node"] as! [String:Any]
                    }
                    for node in nodes {
                        guard let id = node["id"] as? Int, let name = node["name"] as? String, let code = node["code"] as? String else {
                            let alert = self.createAlert(title: "Error", message: "Bad response data")
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                        let poll = Poll(id: id, name: name, code: code)
                        updatedLivePolls.append(poll)
                    }
                    self.livePolls = updatedLivePolls
                }
                DispatchQueue.main.async {
                    self.homeTableView.reloadData()
                }
            } else {
                return
            }
        })

        
    }
    
    // Generate poll code
    func getNewPollCode() {
        GeneratePollCode().make()
            .then{ code -> Void in
                UserDefaults.standard.setValue(code, forKey: "pollCode")
            }.catch { error -> Void in
                print(error)
                return
        }
    }
    
    @objc func createNewPoll() {
        // Make sure poll code exists
        if (UserDefaults.standard.object(forKey: "pollCode") == nil) {
            GeneratePollCode().make()
                .then{ code -> Void in
                    UserDefaults.standard.setValue(code, forKey: "pollCode")
                    let createQuestionVC = CreateQuestionViewController()
                    self.navigationController?.pushViewController(createQuestionVC, animated: true)
                }.catch { error -> Void in
                    print(error)
                    return
            }
        } else {
            let createQuestionVC = CreateQuestionViewController()
            self.navigationController?.pushViewController(createQuestionVC, animated: true)
        }
    }
    
    func savedPollsExist() -> Bool {
        if (UserDefaults.standard.value(forKey: "adminSavedPolls") == nil) {
            return false
        }
        let pollsData = UserDefaults.standard.value(forKey: "adminSavedPolls") as! Data
        let polls = NSKeyedUnarchiver.unarchiveObject(with: pollsData) as! [Poll]
        return (polls.count >= 1)
    }
    
    func joinSession(textField: UITextField, isValidCode: Bool) {
        if isValidCode {
            let parameters: Parameters = [
                "codes": [textField.text!]
            ]
            requestJSON(route: "http://localhost:3000/api/v1/polls/live/", method: .post, parameters: parameters, completion: { json in
                if let data = json["data"] as? [[String:Any]] {
                    if (data.count == 0) {
                        textField.text = ""
                        let alert = self.createAlert(title: "Error", message: "No live session detected for code entered.")
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        if let node = data[0]["node"] as? [String:Any] {
                            print("node: \(node)")
                            guard let id = node["id"] as? Int, let name = node["name"] as? String, let code = node["code"] as? String else {
                                let alert = self.createAlert(title: "Error", message: "Bad response data")
                                self.present(alert, animated: true, completion: nil)
                                return
                            }
                            let poll = Poll(id: id, name: name, code: code)
                            let liveSessionVC = LiveSessionViewController()
                            liveSessionVC.poll = poll
                            self.view.endEditing(true)
                            textField.text = ""
                            self.navigationController?.pushViewController(liveSessionVC, animated: true)
                        } else {
                            let alert = self.createAlert(title: "Error", message: "Bad response data")
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                    }
                } else {
                    let alert = self.createAlert(title: "Error", message: "Bad response data")
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            })
        }
    }
        
}
