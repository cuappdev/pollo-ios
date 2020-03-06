//
//  Keys.swift
//  Pollo
//
//  Created by Kevin Chan on 3/6/20.
//  Copyright © 2020 CornellAppDev. All rights reserved.
//

import Foundation

struct Keys {

    static let announcementsCommonPath = Keys.keyDict["announcements-common-path"] as! String
    static let announcementsHost = Keys.keyDict["announcements-host"] as! String
    static let announcementsPath = Keys.keyDict["announcements-path"] as! String
    static let announcementsScheme = Keys.keyDict["announcements-scheme"] as! String
    static let apiDevURL = Keys.keyDict["api-dev-url"] as! String
    static let apiURL = Keys.keyDict["api-url"] as! String
    static let fabricAPIKey = Keys.keyDict["fabric-api-key"] as! String

    static var hostURL: String {
        #if DEBUG
        return apiDevURL
        #else
        return apiURL
        #endif
    }


    private static let keyDict: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) else { return [:] }
        return dict
    }()

}
