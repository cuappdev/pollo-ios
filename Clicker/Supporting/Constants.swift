//
//  Constants.swift
//  Clicker
//
//  Created by Keivan Shahida on 10/15/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import Foundation
import UIKit

enum QuestionType: CustomStringConvertible {
    case multipleChoice
    case freeResponse
    
    var description : String {
        switch self {
        case .multipleChoice: return "Multiple Choice"
        case .freeResponse: return "Free Response"
        }
    }
    
    var other: QuestionType {
        switch self {
        case .multipleChoice: return .freeResponse
        case .freeResponse: return .multipleChoice
        }
    }
}

struct Identifiers {
    static let multipleChoice = "MULTIPLE_CHOICE"
    static let freeResponse = "FREE_RESPONSE"
    static let significantEventsIdentifier = "significantEvents"
    static let addMoreOptionCellID = "addMoreOptionCellID"
    static let createMCOptionCellID = "createMCOptionCellID"
}

struct Routes {
    static let start = "server/poll/start"
    static let end = "server/poll/end"
    static let results = "server/poll/results"
    static let tally = "server/poll/tally"
    static let upvote = "server/poll/upvote"
}

enum Keys: String {
    case apiURL = "api-url"
    case apiDevURL = "api-dev-url"
    case fabricAPIKey = "fabric-api-key"
    
    var value: String {
        return Keys.keyDict[rawValue] as! String
    }
    
    static var hostURL: Keys {
        #if DEV_SERVER
        return Keys.apiDevURL
        #else
        return Keys.apiURL
        #endif
    }
    
    private static let keyDict: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) else { return [:] }
        return dict
    }()
}

struct Device {
    static let id: String = {
        if let deviceId = UIDevice.current.identifierForVendor?.uuidString {
            return deviceId
        } else {
            return UUID().uuidString
        }
    }()
    
    private init() {}
}

struct Google {
    static let googleClientID = "43978214891-pk0scb60nvn2ofa5acccd58k79n4llkg.apps.googleusercontent.com"
    
    private init() {}
}

// let hostURL = "http://clicker-backend.cornellappdev.com"
let hostURL = "http://localhost:3000"
