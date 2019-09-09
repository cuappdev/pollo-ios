//
//  HamburgerCardModel.swift
//  Pollo
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

enum HamburgerCardState {
    case top, bottom
}

class HamburgerCardModel {

    let identifier = UUID().uuidString
    var state: HamburgerCardState

    init(state: HamburgerCardState) {
        self.state = state
    }

}

extension HamburgerCardModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? HamburgerCardModel else { return false }
        return identifier == object.identifier
    }

}
