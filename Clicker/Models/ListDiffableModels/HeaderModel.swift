//
//  HeaderModel.swift
//  Clicker
//
//  Created by Mindy Lou on 3/8/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import IGListKit

/// Represents a header title (ex. "Attendance", "Live Questions").
class HeaderModel {

    let identifier = UUID().uuidString
    var title: String

    init(title: String) {
        self.title = title
    }
}

extension HeaderModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? HeaderModel else { return false }
        return identifier == object.identifier
    }

}
