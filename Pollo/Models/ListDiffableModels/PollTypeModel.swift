//
//  PollTypeModel.swift
//  Pollo
//
//  Created by Kevin Chan on 8/27/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation
import IGListKit

enum PollType {
    case created, joined
}

class PollTypeModel {

    let identifier = UUID().uuidString
    var pollType: PollType
    var sessions: [Session]?

    init(pollType: PollType, sessions: [Session]?) {
        self.pollType = pollType
        self.sessions = sessions
    }
}

extension PollTypeModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? PollTypeModel else { return false }
        return identifier == object.identifier
    }

}
