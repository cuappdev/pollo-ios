//
//  Poll.swift
//  Clicker
//
//  Created by Kevin Chan on 2/3/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

enum QuestionType {
    case multipleChoice
    case freeResponse
}

class Poll {

    var id: Int?
    var text: String
    var questionType: QuestionType
    var options: [String]?
    var results: [String:Any]?
    // results format:
    // MULTIPLE_CHOICE: {'A': {'text': 'Blue', 'count': 3}, ...}
    // FREE_RESPONSE: {'Blue': {'text': 'Blue', 'count': 3}, ...}
    var isLive: Bool = false
    var isShared: Bool = false

    // MARK: SORTED BY DATE POLL INITIALIZER
    init(id: Int, text: String, results: [String:Any], isShared: Bool) {
        self.id = id
        self.text = text
        self.results = results
        self.options = results.map { (key, _) in key }
        self.questionType = (self.options?.count == 0) ? .freeResponse : .multipleChoice
        self.isShared = isShared
    }
    
    // MARK: SEND START POLL INITIALIZER
    init(text: String, options: [String], isLive: Bool, isShared: Bool) {
        self.text = text
        self.options = options
        self.isLive = isLive
        self.results = [:]
        self.questionType = (options.count == 0) ? .freeResponse : .multipleChoice
        for (index, option) in options.enumerated() {
            let mcOption = intToMCOption(index)
            results![mcOption] = ["text": option, "count": 0]
        }
        self.isShared = isShared
    }
    
    // MARK: RECEIVE START POLL INITIALIZER
    init(json: [String:Any]){
        self.id = json["id"] as? Int
        self.text = json["text"] as! String
        if let options = json["options"] as? [String] {
            self.options = options
        } else {
            self.options = []
        }
        let type = json["type"] as? String
        self.questionType = (type == "MULTIPLE_CHOICE") ? .multipleChoice : .freeResponse
        self.isLive = true
    }
    
    init(id: Int, text: String, results: [String:Any], isLive: Bool) {
        self.id = id
        self.text = text
        self.results = results
        self.options = results.map { (key, _) in key }
        self.isLive = isLive
        self.questionType = (self.options?.count == 0) ? .freeResponse : .multipleChoice
    }
    
    // Returns array representation of results
    // Ex) [('Blah', 3), ('Jupiter', 2)...]
    func getFRResultsArray() -> [(String, Int)] {
        var resultsArr: [(String, Int)] = []
        results?.forEach { (key, val) in
            if let choiceJSON = val as? [String:Any] {
                resultsArr.append((key, (choiceJSON["count"] as! Int)))
            }
        }
        return resultsArr
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
