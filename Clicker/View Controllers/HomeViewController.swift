//
//  HomeViewController.swift
//  Clicker
//
//  Created by Keivan Shahida on 9/24/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

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
                
        self.title = "CliquePod"
        
        // let session = Session(id: 4000, delegate: self)
        
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
        
        fetchLiveLectures()
    }
    
    // MARK: - CELLS
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.section) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "liveSessionCell") as! LiveSessionTableViewCell
            let lecture = lectures[indexPath.row]
            let courseID = lectureIDToCourseID[lecture.id]
            let course = courseIDToCourses[courseID!]
            if let name = course?.name {
                cell.sessionLabel.text = "\(name) - Lecture \(lecture.id)"
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "pastSessionCell") as! PastSessionTableViewCell
            cell.course = pastSessions[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.section) {
        case 0:
            print("liveSession")
            let viewController = LiveSessionViewController()
            let lecture = lectures[indexPath.row]
            let courseID = lectureIDToCourseID[lecture.id]
            let course = courseIDToCourses[courseID!]
            viewController.liveLecture = lecture
            viewController.course = course 
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
            return lectures.count 
        case 1:
            return pastSessions.count
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
    }
    
    func endLecture() {
        print("end lecture")
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
        addCourseVC.modalPresentationStyle = .overCurrentContext
        navigationController?.present(addCourseVC, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchLiveLectures()
        
    }
    
    func fetchLiveLectures() {
//        lectures = [Lecture]()
//        courseIDToCourses = [String:Course]()
//        lectureIDToCourseID = [String:String]()
        GetUserCourses(id: "1", role: "student").make()
            .then { courses -> Void in
                print("these are the courses")
                print(courses)
                for course in courses {
                    let courseID = course.id
                    if self.courseIDToCourses[courseID] == nil {
                        GetCourse(id: courseID).make()
                            .then { course -> Void in
                                self.courseIDToCourses[courseID] = course
                                self.tableView.reloadData()
                            }.catch { error -> Void in
                                print("error in GETTING COURSES")
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
                            print("error in GETTING courses' LECTURES")
                            print(error)
                    }
                }
                self.tableView.reloadData()
            
        }
    }
    // USE USER DEFAULTS TO STORE ENROLLED COURSES WHEN USER FIRST LOADS INTO APP???
}
