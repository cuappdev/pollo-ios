//
//  User.swift
//  Clicker
//
//  Created by Kevin Chan on 9/26/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var netID: String
    var name: String
    var courses: Set<Course> = Set<Course>()
    var sessions: [Session] = [Session]()
    
    
    init(netID: String, name: String) {
        self.netID = netID
        self.name = name
    }
    
    func addCourse(_ course: Course) {
        courses.insert(course)
    }
    
    func removeCourse(_ course: Course) {
        courses.remove(course)
    }
    
    func addSession(_ session: Session) {
        sessions.append(session)
    }
    
    func removeSession(_ session: Session) {
        if let index = sessions.index(of: session) {
            sessions.remove(at: index)
        }
    }
    
}
