//
//  CurrentState.swift
//  Clicker
//
//  Created by Kevin Chan on 2/17/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

class CurrentState {
    
    var pollId: Int
    var results: [String:Any]
    var answers: [String:Any]
    
    init(_ pollId: Int, _ results: [String:Any], _ answers: [String:Any]) {
        self.pollId = pollId
        self.results = results
        self.answers = answers
    }
    
    init(json: [String:Any]){
        self.pollId = json["poll"] as! Int
        self.results = json["results"] as! [String:Any]
        self.answers = json["answers"] as! [String:Any]
    }
    
    // GET TOTAL ANSWERS SUBMITTED
    func getTotalCount() -> Int {
        var counter = 0
        for dict in results.values {
            if let d = dict as? [String:Any], let val = d["count"] as? Int {
                counter += val
            }
        }
        return counter
    }
    
    // Returns array representation of results
    // Ex) [('Blah', 3), ('Jupiter', 2)...]
    func getFRResultsArray() -> [(String, Int)] {
        var resultsArr: [(String, Int)] = []
        results.forEach { (key, val) in
            if let choiceJSON = val as? [String:Any] {
                resultsArr.append((key, (choiceJSON["count"] as! Int)))
            }
        }
        return resultsArr
    }
    
}
