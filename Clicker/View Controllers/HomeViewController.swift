//
//  HomeViewController.swift
//  Clicker
//
//  Created by Keivan Shahida on 9/24/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit
import Armchair

class HomeViewController: UITableViewController, SessionDelegate {
    
    var lectures = [Lecture]()
    var courseIDToCourses = [String:Course]()
    var lectureIDToCourseID = [String:String]()
    var pastSessions = [Course(id: "sldhflsg", name: "ASTRO 1101", term: "FALL 2017"),
                        Course(id: "shdgouah", name: "CS 3110", term: "FALL 2017"),
                        Course(id: "alksdfla", name: "ECE 2300", term: "FALL 2017")]
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.title = "Clique"
        
        let signoutBarButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(signout))
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
        tableView.register(EmptyLiveSessionTableViewCell.self, forCellReuseIdentifier: "emptyLiveSessionCell")
        tableView.register(EmptyPastSessionTableViewCell.self, forCellReuseIdentifier: "emptyPastSessionCell")

        fetchLiveLectures()
    }
    
    // MARK: - CELLS
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.section) {
        case 0:
            if lectures.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "emptyLiveSessionCell") as! EmptyLiveSessionTableViewCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "liveSessionCell") as! LiveSessionTableViewCell
                let lecture = lectures[indexPath.row]
                let courseID = lectureIDToCourseID[lecture.id]
                let course = courseIDToCourses[courseID!]
                if let name = course?.name {
                    cell.sessionLabel.text = "\(name) - Lecture \(lecture.id)"
                }
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
            if lectures.count != 0 {
                print("liveSession")
                let viewController = LiveSessionViewController()
                let lecture = lectures[indexPath.row]
                let courseID = lectureIDToCourseID[lecture.id]
                let course = courseIDToCourses[courseID!]
                viewController.liveLecture = lecture
                viewController.course = course
                let navigationController = self.navigationController!
                navigationController.pushViewController(viewController, animated: true)
                Armchair.userDidSignificantEvent(true)
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
            return lectures.count == 0 ? 1 : lectures.count
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
    
    override func viewDidAppear(_ animated: Bool) {
        fetchLiveLectures()
    }
    
    func fetchLiveLectures() {
        GetUserCourses(id: "1", role: "student").make()
            .then { courses -> Void in
                for course in courses {
                    let courseID = course.id
                    if self.courseIDToCourses[courseID] == nil {
                        GetCourse(id: courseID).make()
                            .then { course -> Void in
                                self.courseIDToCourses[courseID] = course
                                self.tableView.reloadData()
                            }.catch { error -> Void in
                                print(error)
                                return
                        }
                    }
                    GetCourseLectures(id: courseID).make()
                        .then { liveLectures -> Void in
                            for lecture in liveLectures {
                                if self.lectureIDToCourseID[lecture.id] == nil {
                                    self.lectures.append(lecture)
                                    self.lectureIDToCourseID[lecture.id] = courseID
                                }
                            }
                            self.tableView.reloadData()
                        }.catch { error in
                            print(error)
                    }
                }
                self.tableView.reloadData()
        }
    }
}
