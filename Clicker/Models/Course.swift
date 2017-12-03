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
    var name: String
    var term: String
    
    init(id: String, name: String, term: String) {
        self.id = id
        self.name = name
        self.term = term
    }
}
