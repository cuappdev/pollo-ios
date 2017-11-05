//
//  HomeViewController.swift
//  Clicker
//
//  Created by Keivan Shahida on 9/24/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController, SessionDelegate {
    
    var liveLecture: Lecture?
    var lectures = [Lecture]()
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.title = "CliquePod"
        
        liveLecture = Lecture("fdgasgserha", "asfgashadfh") //temp
        
        let signoutBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(signout))
        navigationItem.leftBarButtonItem = signoutBarButton
        
        let addCourseButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCourse))
        navigationItem.rightBarButtonItem = addCourseButton
        
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(LiveSessionHeader.self, forHeaderFooterViewReuseIdentifier: "liveSessionHeader")
        tableView.register(PastSessionHeader.self, forHeaderFooterViewReuseIdentifier: "pastSessionHeader")
        tableView.register(LiveSessionTableViewCell.self, forCellReuseIdentifier: "liveSessionCell")
        tableView.register(PastSessionTableViewCell.self, forCellReuseIdentifier: "pastSessionCell")
    }
    
    // MARK: - CELLS
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch(indexPath.section) {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "liveSessionCell") as! LiveSessionTableViewCell
            return cell
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "pastSessionCell") as! PastSessionTableViewCell
            return cell
        default:
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.section) {
        case 0:
            print("liveSession")
            let viewController = LiveSessionViewController()
            viewController.liveLecture = liveLecture
            let navigationController = self.navigationController!
            navigationController.pushViewController(viewController, animated: true)
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
            return Constants.Headers.Height.liveSession
        case 1:
            return Constants.Headers.Height.pastSession
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
        case 0:
            return liveLecture == nil ? 0 : 1
        case 1:
            return 3 //TEMP
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
    
    func beginLecture(_ lectureId: String) {
        print("begin lecture")
        GetLecture(id: lectureId).make()
            .then{ lecture -> Void in
                self.liveLecture = lecture
                self.tableView.reloadData()
            }
            .catch{ error in
                print(error.localizedDescription)
        }
    }
    
    func endLecture() {
        print("end lecture")
        DeleteLecture(id: (liveLecture?.id)!).make()
            .then{ lecture -> Void in
                self.liveLecture = nil
                self.tableView.reloadData()
            }
            .catch{ error in
                print(error.localizedDescription)
        }
    }
    
    func beginQuestion(_ question: Question) {
        print("begin question")        
    }
    
    func endQuestion() {
        print("end question")
    }
    
    func postResponses(_ answers: [Answer]) {
        print("post responses")
    }
    
    func joinLecture(_ lectureId: String) {
        // socket.emit("join_lecture", lectureId)
    }
    
    func sendResponse(_ answer: Answer) {
        // socket.emit("send_response", answer)
    }
    
    
    // MARK: - SIGN OUT
    @objc func signout() {
        GIDSignIn.sharedInstance().signOut()
        let login = LoginViewController()
        present(login, animated: true, completion: nil)
    }
    
    @objc func addCourse() {
        let addCourseVC = AddCourseViewController()
        navigationController?.pushViewController(addCourseVC, animated: true)
    }
}
