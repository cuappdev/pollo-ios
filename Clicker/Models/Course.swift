//
//  Course.swift
//  Clicker
//
//  Created by Kevin Chan on 9/26/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

enum SubjectType {
    // Will add rest later if we plan
    // on keeping this
    case CS, INFO, MATH
}

class Course: NSObject {
    
    var subject: SubjectType
    var courseNumber: Int
    var name: String
    var professors: Set<User> = Set<User>()
    var students: Set<User> = Set<User>()
    
    init(subject: SubjectType, courseNumber: Int, name: String) {
        self.subject = subject
        self.courseNumber = courseNumber
        self.name = name
    }
    
    func addProfessor(_ professor: User) {
        professors.insert(professor)
    }
    
    func removeProfessor(_ professor: User) {
        professors.remove(professor)
    }
    
    func addStudent(_ student: User) {
        students.insert(student)
    }
    
    func removeStudent(_ student: User) {
        students.remove(student)
    }
    
    
    
}
