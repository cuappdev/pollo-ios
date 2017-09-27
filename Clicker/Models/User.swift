//
//  User.swift
//  Clicker
//
//  Created by Kevin Chan on 9/26/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

class User : NSObject {
    
    var netID: String
    var name: String
    var courses: [Course] = [Course]()
    var sessions: [Session] = [Session]()
    
    
    init(netID: String, name: String) {
        self.netID = netID
        self.name = name
    }
    
    func addCourse(_ course: Course) {
        courses.append(course)
    }
    
    func removeCourse(_ course: Course) {
        for i in 0...(courses.count - 1) {
            if courses[i].courseCode == course.courseCode {
                courses.remove(at: i)
            }
        }
    }
    
    func addSession(_ session: Session) {
        sessions.append(session)
    }
    
    
}
