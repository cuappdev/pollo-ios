//
//  GroupControlsHeaderModel.swift
//  Clicker
//
//  Created by Mathew Scullin on 3/11/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import Foundation
import IGListKit

class GroupControlsHeaderModel {

    let identifier = UUID().uuidString
    var header: String

    init(header: String) {
        self.header = header
    }

}

extension GroupControlsHeaderModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? HeaderModel else { return false }
        return identifier == object.identifier
    }

}
