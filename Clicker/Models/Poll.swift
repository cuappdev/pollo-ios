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
        var counter = 0
        for (key, value) in results {
            if let choiceJSON = value as? [String:Any] {
                counter += choiceJSON["count"] as! Int
            }
        }
        return counter
    }

}
