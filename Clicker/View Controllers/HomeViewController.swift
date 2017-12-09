//
//  HomeViewController.swift
//  Clicker
//
//  Created by Keivan Shahida on 9/24/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController, SessionDelegate {
    
    var liveLectures = [[String:Any]]()
    var pastSessions = [Course(id: "sldhflsg", name: "ASTRO 1101", term: "FALL 2017"),
                        Course(id: "shdgouah", name: "CS 3110", term: "FALL 2017"),
                        Course(id: "alksdfla", name: "ECE 2300", term: "FALL 2017")] //TEMP
    var refControl: UIRefreshControl!
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Clique"
        
        let signoutBarButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(signout))
        navigationItem.leftBarButtonItem = signoutBarButton
        
        let addCourseButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCourse))
        navigationItem.rightBarButtonItem = addCourseButton
        
        
        refControl = UIRefreshControl()
        refControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refControl.tintColor = .white
        refControl.backgroundColor = .clickerBlue
        
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(LiveSessionHeader.self, forHeaderFooterViewReuseIdentifier: "liveSessionHeader")
        tableView.register(PastSessionHeader.self, forHeaderFooterViewReuseIdentifier: "pastSessionHeader")
        tableView.register(LiveSessionTableViewCell.self, forCellReuseIdentifier: "liveSessionCell")
        tableView.register(PastSessionTableViewCell.self, forCellReuseIdentifier: "pastSessionCell")
        tableView.register(EmptyLiveSessionTableViewCell.self, forCellReuseIdentifier: "emptyLiveSessionCell")
        tableView.register(EmptyPastSessionTableViewCell.self, forCellReuseIdentifier: "emptyPastSessionCell")
        tableView.addSubview(refControl)
        
        
        fetchLiveLectures()
        
        let appDelegate = AppDelegate()
        if let significantEvents : Int = UserDefaults.standard.integer(forKey: "significantEvents"){
            if significantEvents > 12 {
                appDelegate.requestReview()
                UserDefaults.standard.set(0, forKey:"significantEvents")
            }
        }
    }
    
    // MARK: - CELLS
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.section) {
        case 0:
            if liveLectures.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "emptyLiveSessionCell") as! EmptyLiveSessionTableViewCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "liveSessionCell") as! LiveSessionTableViewCell
                let name = liveLectures[indexPath.row]["courseName"] as! String
                let lectureId = liveLectures[indexPath.row]["id"] as! Int
                cell.sessionText = "\(name) - Lecture \(lectureId)"
                return cell
            }
        case 1:
            if pastSessions.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "emptyPastSessionCell") as! EmptyPastSessionTableViewCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "pastSessionCell") as! PastSessionTableViewCell
                cell.course = pastSessions[indexPath.row]
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.section) {
        case 0:
            if liveLectures.count != 0 {
                print("liveSession")
                let viewController = LiveSessionViewController()
                let liveLecture = liveLectures[indexPath.row]
                viewController.liveLectureId = liveLecture["id"] as! Int
                viewController.courseName = liveLecture["courseName"] as! String
                let navigationController = self.navigationController!
                navigationController.pushViewController(viewController, animated: true)
                
                if let significantEvents : Int = UserDefaults.standard.integer(forKey: "significantEvents"){
                    UserDefaults.standard.set(significantEvents + 1, forKey:"significantEvents")
                }
            }
        case 1:
            print("pastSession")
        default:
            print("default")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - SECTIONS
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UITableViewHeaderFooterView()
        switch (section) {
        case 0:
            headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "liveSessionHeader") as! LiveSessionHeader
            return headerView
        case 1:
            headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "pastSessionHeader") as! PastSessionHeader
            return headerView
        default:
            return headerView
        }
    }
    
    override  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch(section){
        case 0:
            return 44.5
        case 1:
            return 53.5
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
        case 0:
            return liveLectures.count == 0 ? 1 : liveLectures.count
        case 1:
            return pastSessions.count == 0 ? 1 : pastSessions.count
        default:
            return 0
        }
    }
    
    // MARK: - SESSIONS
    func sessionConnected() {
        print("session connected")
    }
    
    func sessionDisconnected() {
        print("session disconnected")
    }
    
    func beginQuestion(_ question: Question) {
        print("begin question")        
    }
    
    func endQuestion(_ question: Question) {
        print("end question")
    }
    
    func postResponses(_ answers: [Answer]) {
        print("post responses")
    }
    
    func sendResponse(_ answer: Answer) {
        print("send responses")
    }
    
    // MARK: - SIGN OUT
    @objc func signout() {
        
        let alert = UIAlertController(title: "Sign out", message: "Are you sure you want to sign out?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign out", style: .default, handler: { (isCompleted) in
            GIDSignIn.sharedInstance().signOut()
            let login = LoginViewController()
            self.present(login, animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func addCourse() {
        let addCourseVC = AddCourseViewController()
        addCourseVC.modalPresentationStyle = .overCurrentContext
        navigationController?.present(addCourseVC, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        fetchLiveLectures()
    }
    
    @objc func handleRefresh() {
        fetchLiveLectures()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refControl.endRefreshing()
        }
    }
    
    @objc func fetchLiveLectures() {
        GetLiveLectures(studentId: 1).make()
            .then { liveLecs -> Void in
                self.liveLectures = liveLecs
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }.catch { error -> Void in
                print(error)
                return
            }
    }
}
