//
//  FRInputModel.swift
//  Pollo
//
//  Created by Kevin Chan on 9/10/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

class FRInputModel: ListDiffable {

    var filter: [String]?
    var text: String?

    let identifier = UUID().uuidString

    init(pollFilter: PollFilter? = nil) {
        self.filter = pollFilter?.filter
        self.text = pollFilter?.text
    }

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? FROptionModel else { return false }
        return identifier == object.identifier
    }

}
