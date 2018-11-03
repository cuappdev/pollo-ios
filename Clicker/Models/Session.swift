//
//  Session.swift
//  Clicker
//
//  Created by Kevin Chan on 10/30/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import IGListKit

class Session {
    
    var id: Int
    var name: String
    var code: String
    var description: String = ""
    var isLive: Bool?
    let identifier = UUID().uuidString
    
    init(id: Int, name: String, code: String) {
        self.id = id
        self.name = name
        self.code = code
    }
    
    init(id: Int, name: String, code: String, latestActivity: String, isLive: Bool) {
        self.id = id
        self.name = name
        self.code = code
        self.description = latestActivity
        self.isLive = isLive
    }
    
}

extension Session: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if (self === object) { return true }
        guard let object = object as? Session else { return false }
        return identifier == object.identifier
    }
    
}
