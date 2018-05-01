//
//  Poll.swift
//  Clicker
//
//  Created by Kevin Chan on 2/3/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class Poll {

    var id: Int?
    var text: String
    var options: [String]?
    var results: [String:Any]?
    var isLive: Bool = false
    var isShared: Bool = false

    // MARK: SORTED BY DATE POLL INITIALIZER
    init(id: Int, text: String, results: [String:Any]) {
        self.id = id
        self.text = text
        self.results = results
    }
    
    // MARK: SEND START POLL INITIALIZER
    init(text: String, options: [String], isLive: Bool) {
        self.text = text
        self.options = options
        self.isLive = isLive
        self.results = [:]
        for (index, option) in options.enumerated() {
            let mcOption = intToMCOption(index)
            results![mcOption] = ["text": option, "count": 0]
        }
    }
    
    // MARK: RECEIVE START POLL INITIALIZER
    init(json: [String:Any]){
        self.id = json["id"] as! Int
        self.text = json["text"] as! String
        if let options = json["options"] as? [String] {
            self.options = options
        } else {
            self.options = []
        }
        self.isLive = true
    }
    
    init(id: Int, text: String, results: [String:Any], isLive: Bool) {
        self.id = id
        self.text = text
        self.results = results
        self.isLive = isLive
    }
    
    func getTotalResults() -> Int {
        return results!.reduce(0) { (res, arg1) -> Int in
            let (_, value) = arg1
            if let choiceJSON = value as? [String:Any] {
                return res + (choiceJSON["count"] as! Int)
            } else {
                return 0
            }
        }
    }

}
