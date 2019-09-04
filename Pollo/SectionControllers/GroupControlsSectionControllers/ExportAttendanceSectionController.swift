//
//  ExportAttendanceSectionController.swift
//  Pollo
//
//  Created by Mindy Lou on 3/9/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import IGListKit
import UIKit

protocol ExportAttendanceSectionControllerDelegate: class {
    func exportAttendanceSectionControllerButtonWasTapped()
}

class ExportAttendanceSectionController: ListSectionController {

    // MARK: Data vars
    var exportAttendanceModel: ExportAttendanceModel!
    weak var delegate: ExportAttendanceSectionControllerDelegate?

    // MARK: Constants
    let cellHeight: CGFloat = 77

    init(delegate: ExportAttendanceSectionControllerDelegate) {
        super.init()
        self.delegate = delegate
    }

    // MARK: ListSectionController
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        return CGSize(width: containerSize.width, height: cellHeight)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: ExportButtonCell.self, for: self, at: index) as! ExportButtonCell
        cell.configure(for: exportAttendanceModel.isExportable)
        cell.delegate = self
        return cell
    }

    override func didUpdate(to object: Any) {
        exportAttendanceModel = object as? ExportAttendanceModel
    }
}

// MARK: - ExportButtonCellDelegate
extension ExportAttendanceSectionController: ExportButtonCellDelegate {

    func exportButtonCellButtonWasTapped() {
        delegate?.exportAttendanceSectionControllerButtonWasTapped()
    }

}
