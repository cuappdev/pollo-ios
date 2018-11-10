//
//  Draft.swift
//  Clicker
//
//  Created by Kevin Chan on 4/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation
import IGListKit

class Draft: Codable {
    
    var id: Int
    var text: String
    var options: [String]
    let identifier: String = UUID().uuidString
    
    init(id: Int, text: String, options: [String]) {
        self.id = id
        self.text = text
        self.options = options
    }
    
}

extension Draft: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? Draft else { return false }
        return object.identifier == identifier
    }
    
}
