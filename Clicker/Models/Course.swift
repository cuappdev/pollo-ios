//
//  Course.swift
//  Clicker
//
//  Created by Kevin Chan on 9/26/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit


class Course {
    
    var id: String
    var name: String // i.e. "CS 2110"
    var term: String
    var professors: [User] = [User]()
    var students: [User] = [User]()
    
    init(id: String, name: String, term: String) {
        self.id = id
        self.name = name
        self.term = term
    }
    
    func addProfessor(_ professor: User) {
        professors.append(professor)
    }
    
    func removeProfessor(_ professor: User) {
        if let index = professors.index(of: professor) {
            professors.remove(at: index)
        }
    }
    
    func addStudent(_ student: User) {
        students.append(student)
    }
    
    func removeStudent(_ student: User) {
        if let index = students.index(of: student) {
            students.remove(at: index)
        }
    }
    
    
    
}
