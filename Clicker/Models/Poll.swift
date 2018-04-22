//
//  Poll.swift
//  Clicker
//
//  Created by Kevin Chan on 2/3/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class Poll {

    var id: Int
    var text: String
    var results: [String:Any]
    var date: String?
    var isLive: Bool = false


    init(id: Int, text: String, results: [String:Any]) {
        self.id = id
        self.text = text
        self.results = results
    }
    
    init(id: Int, text: String, results: [String:Any], isLive: Bool) {
        self.id = id
        self.text = text
        self.results = results
        self.isLive = isLive
    }
    
    init(id: Int, text: String, results: [String:Any], date: String) {
        self.id = id
        self.text = text
        self.results = results
        self.date = date
    }
    
    func getTotalResults() -> Int {
        return results.reduce(0) { (res, arg1) -> Int in
            let (key, value) = arg1
            if let choiceJSON = value as? [String:Any] {
                return res + (choiceJSON["count"] as! Int)
            } else {
                return 0
            }
        }
    }

}
