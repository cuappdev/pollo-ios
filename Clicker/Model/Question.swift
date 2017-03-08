//
//  Question.swift
//  Clicker
//
//  Created by AE7 on 3/8/17.
//  Copyright © 2017 cuappdev. All rights reserved.
//

import RealmSwift

class Question: Object {
    dynamic var id: Int = 0
    dynamic var title: String = ""
    let answers = [String]()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
