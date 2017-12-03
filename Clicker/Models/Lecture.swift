//
//  Lecture.swift
//  Clicker
//
//  Created by Kevin Chan on 10/14/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

class Lecture {
    
    var id: String
    var dateTime: String
    var questions: [Question] = [Question]()
    
    init(_ id: String, _ dateTime: String) {
        self.id = id
        self.dateTime = dateTime
    }
}
