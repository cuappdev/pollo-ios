//
//  PollsDateSectionController.swift
//  Clicker
//
//  Created by Kevin Chan on 11/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

protocol PollsDateAttendanceSectionControllerDelegate {
    func pollsDateAttendanceSectionControllerDidTap(for pollsDateAttendanceModel: PollsDateAttendanceModel)
}

class PollsDateAttendanceSectionController: ListSectionController {

    // MARK: - Data Vars
    var pollsDateAttendanceModel: PollsDateAttendanceModel!
    var delegate: PollsDateAttendanceSectionControllerDelegate!

    // MARK: - Constants
    let cellHeight: CGFloat = 61

    init(delegate: PollsDateAttendanceSectionControllerDelegate) {
        self.delegate = delegate
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        return CGSize(width: containerSize.width, height: cellHeight)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: PollsDateAttendanceCell.self, for: self, at: index) as! PollsDateAttendanceCell
        cell.configure(for: pollsDateAttendanceModel)
        return cell
    }

    override func didUpdate(to object: Any) {
        pollsDateAttendanceModel = object as? PollsDateAttendanceModel
    }

    override func didSelectItem(at index: Int) {
        guard let cell = collectionContext?.cellForItem(at: index, sectionController: self) as? PollsDateAttendanceCell else { return }
        cell.toggleCheckBox()
        delegate.pollsDateAttendanceSectionControllerDidTap(for: pollsDateAttendanceModel)
    }

    override func didDeselectItem(at index: Int) {
        guard let cell = collectionContext?.cellForItem(at: index, sectionController: self) as? PollsDateAttendanceCell else { return }
        cell.toggleCheckBox()
        delegate.pollsDateAttendanceSectionControllerDidTap(for: pollsDateAttendanceModel)
    }

}
