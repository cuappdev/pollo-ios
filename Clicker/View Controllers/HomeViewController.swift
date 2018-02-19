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
    var savedSessionsTableView: UITableView!
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UserDefaults.standard.set(nil, forKey: "savedPolls")
        view.backgroundColor = .clickerBackground
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
        
        //SAVED SESSIONS
        savedSessionsTableView = UITableView()
        savedSessionsTableView.delegate = self
        savedSessionsTableView.dataSource = self
        savedSessionsTableView.separatorStyle = .none
        savedSessionsTableView.clipsToBounds = true
        savedSessionsTableView.register(JoinSessionCell.self, forCellReuseIdentifier: "joinSessionCellID")
        savedSessionsTableView.register(SavedSessionHeader.self, forHeaderFooterViewReuseIdentifier: "savedSessionHeaderID")
        savedSessionsTableView.register(SavedSessionCell.self, forCellReuseIdentifier: "savedSessionCellID")
        savedSessionsTableView.backgroundColor = .clear
        view.addSubview(savedSessionsTableView)
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
        
        savedSessionsTableView.snp.updateConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(whiteView.snp.top)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        // Get new poll code if needed
        getNewPollCode()
        // Reload TableViews
        savedSessionsTableView.reloadData()
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "joinSessionCellID", for: indexPath) as! JoinSessionCell
            cell.joinSessionCellDelegate = self
            return cell
        } else {
            let polls = decodeObjForKey(key: "savedPolls") as! [Poll]
            let cell = tableView.dequeueReusableCell(withIdentifier: "savedSessionCellID", for: indexPath) as! SavedSessionCell
            cell.sessionText = polls[indexPath.row].name
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if (UserDefaults.standard.value(forKey: "savedPolls") == nil) {
                return 0
            }
            let pollsData = UserDefaults.standard.value(forKey: "savedPolls") as! Data
            let polls = NSKeyedUnarchiver.unarchiveObject(with: pollsData) as! [Poll]
            return polls.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        } else {
            let polls = decodeObjForKey(key: "savedPolls") as! [Poll]
            let selectedPoll = polls[indexPath.row]
            UserDefaults.standard.set(selectedPoll.code, forKey: "pollCode")
            let createQuestionVC = CreateQuestionViewController()
            createQuestionVC.oldPoll = polls[indexPath.row]
            self.navigationController?.pushViewController(createQuestionVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UITableViewHeaderFooterView()
        } else {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "savedSessionHeaderID") as! SavedSessionHeader
            headerView.backgroundView?.backgroundColor = UIColor.red
            headerView.contentView.backgroundColor = UIColor.red
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 40
        }
    }
    
    // MARK: - SESSIONS / POLLS
    
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
        if (UserDefaults.standard.value(forKey: "savedPolls") == nil) {
            return false
        }
        let pollsData = UserDefaults.standard.value(forKey: "savedPolls") as! Data
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
