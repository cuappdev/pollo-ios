//
//  Lecture.swift
//  Clicker
//
//  Created by AE7 on 3/8/17.
//  Copyright © 2017 cuappdev. All rights reserved.
//

import RealmSwift

class Lecture: Object {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
