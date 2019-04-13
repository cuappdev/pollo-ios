//
//  CurrentStateParser.swift
//  Clicker
//
//  Created by Kevin Chan on 9/13/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation
import SwiftyJSON

//class CurrentStateParser: Parser {
////
////    typealias ItemType = CurrentState
////
////    static func parseItem(json: JSON) -> CurrentState {
////        let pollId = json[ParserKeys.pollKey].intValue
////        let results = json[ParserKeys.resultsKey].dictionaryValue
////        let pollResults = formatResults(results: results)
////        let answers = json[ParserKeys.answersKey].dictionaryValue
////        let pollAnswers = formatAnswers(answers: answers)
////        let upvotesJSON = json[ParserKeys.upvotesKey].dictionaryObject
////        var upvotes: [String: [String]] = [:]
////        upvotesJSON?.forEach { (key, value) in
////            if let answerIds = value as? [String] {
////                upvotes[key] = answerIds
////            }
////        }
////        return CurrentState(pollId, pollResults, pollAnswers, upvotes)
////    }
//
//}
