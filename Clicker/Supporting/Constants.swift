//
//  Constants.swift
//  Clicker
//
//  Created by Keivan Shahida on 10/15/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import Foundation
import UIKit

let MULTIPLE_CHOICE = "MULTIPLE_CHOICE"
let FREE_RESPONSE = "FREE_RESPONSE"
let significantEventsIdentifier = "significantEvents"
let addMoreOptionCellID = "addMoreOptionCellID"
let createMCOptionCellID = "createMCOptionCellID"

let server_poll_end = "server/poll/end"
let server_poll_results = "server/poll/results"
let server_poll_tally = "server/poll/tally"
let server_poll_upvote = "server/poll/upvote"

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
