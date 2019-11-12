//
//  Draft.swift
//  Pollo
//
//  Created by Kevin Chan on 4/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation
import IGListKit

class Draft: Codable {

    let identifier: String = UUID().uuidString
    var id: String
    var options: [String]
    var text: String

    init(id: String, text: String, options: [String]) {
        self.id = id
        self.options = options
        self.text = text
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
