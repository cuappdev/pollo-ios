//
//  ExportAttendanceModel.swift
//  Clicker
//
//  Created by Mindy Lou on 3/9/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import UIKit
import IGListKit

class ExportAttendanceModel {
    
    var isExportable: Bool
    let identifier = UUID().uuidString

    init(isExportable: Bool) {
        self.isExportable = isExportable
    }

}

extension ExportAttendanceModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? HeaderModel else { return false }
        return identifier == object.identifier
    }

}
