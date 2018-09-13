//
//  CurrentStateParser.swift
//  Clicker
//
//  Created by Kevin Chan on 9/13/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation
import SwiftyJSON

class CurrentStateParser: Parser {
    
    typealias itemType = CurrentState
    
    static func parseItem(json: JSON) -> CurrentState {
        let pollId = json[ParserKeys.pollKey].intValue
        let results = json[ParserKeys.resultsKey].dictionaryValue
        let answers = json[ParserKeys.answersKey].dictionaryValue
        return CurrentState(pollId, results, answers)
    }
    
}
