//
//  Course.swift
//  Clicker
//
//  Created by Kevin Chan on 9/26/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit


class Course {
    
    var courseCode: String // i.e. "CS 2110"
    var name: String
    var professors: [User] = [User]()
    var students: [User] = [User]()
    
    init(courseCode: String, name: String) {
        self.courseCode = courseCode
        self.name = name
    }
    
    func addProfessor(_ professor: User) {
        professors.append(professor)
    }
    
    func removeProfessor(_ professor: User) {
        for i in 0...(professors.count - 1) {
            if professors[i].netID == professor.netID {
                professors.remove(at: i)
            }
        }
    }
    
    func addStudent(_ student: User) {
        students.append(student)
    }
    
    func removeStudent(_ student: User) {
        for i in 0...(students.count - 1) {
            if students[i].netID == student.netID {
                professors.remove(at: i)
            }
        }
    }
    
    
    
}
