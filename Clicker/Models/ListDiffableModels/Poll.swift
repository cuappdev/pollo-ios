//
//  Poll.swift
//  Clicker
//
//  Created by Kevin Chan on 2/3/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import IGListKit

enum PollState {
    case live
    case ended
    case shared
}

class Poll {
    
    let identifier = UUID().uuidString as NSString
    var id: Int!
    var text: String
    var questionType: QuestionType
    var options: [String]
    var results: [String:Any]
    var state: PollState!
    // results format:
    // MULTIPLE_CHOICE: {'A': {'text': 'Blue', 'count': 3}, ...}
    // FREE_RESPONSE: {'Blue': {'text': 'Blue', 'count': 3}, ...}
    
    // MARK: - Constants
    let defaultIdentifier = UUID().uuidString
    let idKey = "key"
    let textKey = "text"
    let countKey = "count"
    let optionsKey = "options"
    let typeKey = "type"
    
    // MARK: SORTED BY DATE POLL INITIALIZER
    init(id: Int, text: String, results: [String:Any], type: QuestionType, state: PollState) {
        self.id = id
        self.text = text
        self.results = results
        self.options = Array(results.keys)
        self.questionType = type
        self.state = state
    }
    
    // MARK: SEND START POLL INITIALIZER
    init(text: String, options: [String], type: QuestionType, state: PollState) {
        self.text = text
        self.options = options
        self.results = [:]
        self.questionType = type
        options.enumerated().forEach { (index, option) in
            let mcOption = intToMCOption(index)
            results[mcOption] = [textKey: option, countKey: 0]
        }
        self.state = state
    }
    
    // MARK: RECEIVE START POLL INITIALIZER
    init(json: [String:Any]){
        self.id = json[idKey] as? Int
        if let text = json[textKey] as? String {
            self.text = text
        } else {
            self.text = ""
        }
        if let options = json[optionsKey] as? [String] {
            self.options = options
        } else {
            self.options = []
        }
        self.results = [:]
        let type = json[typeKey] as? String
        self.questionType = (type == Identifiers.multipleChoiceIdentifier) ? .multipleChoice : .freeResponse
        self.state = .live
    }
    
    // Returns array representation of results
    // Ex) [('Blah', 3), ('Jupiter', 2)...]
    func getFRResultsArray() -> [(String, Int)] {
        var resultsArr: [(String, Int)] = []
        results.forEach { (key, val) in
            if let choiceJSON = val as? [String:Any], let numSelected = choiceJSON[countKey] as? Int {
                resultsArr.append((key, numSelected))
            }
        }
        return resultsArr
    }
    
    func getTotalResults() -> Float {
        return results.reduce(0) { (res, arg1) -> Float in
            let (_, value) = arg1
            if let choiceJSON = value as? [String:Any], let numSelected = choiceJSON[countKey] as? Float {
                return res + numSelected
            }
            return 0
        }
    }
}

extension Poll: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        guard let id = id else {
            return defaultIdentifier as NSString
        }
        return "\(id)" as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if (self === object) { return true }
        guard let object = object as? Poll else { return false }
        return id == object.id && text == object.text && questionType == object.questionType
    }
    
}
