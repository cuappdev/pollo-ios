//
//  Session.swift
//  Clicker
//
//  Created by Kevin Chan on 10/30/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import IGListKit

struct Code: Codable {
    
    var code: String
    
}

class Session: Codable {
    
    var id: Int
    var name: String
    var code: String
    var description: String?
    var updatedAt: String?
    var isLive: Bool?
    var location: Coord
    var isLocationRestricted: Bool
    let identifier = UUID().uuidString
    
    init(id: Int, name: String, code: String, isLocationRestricted: Bool, location: Coord) {
        self.id = id
        self.name = name
        self.code = code
        self.isLocationRestricted = isLocationRestricted
        self.location = location
    }
    
    init(id: Int, name: String, code: String, latestActivity: String?, isLive: Bool?, isLocationRestricted: Bool, location: Coord) {
        self.id = id
        self.name = name
        self.code = code
        self.description = latestActivity
        self.isLive = isLive
        self.isLocationRestricted = isLocationRestricted
        self.location = location
    }
    
}

extension Session: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? Session else { return false }
        return identifier == object.identifier
    }
    
}
