//
//  PollsDateSectionController.swift
//  Clicker
//
//  Created by Kevin Chan on 11/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

protocol PollsDateAttendanceSectionControllerDelegate {


}

class PollsDateAttendanceSectionController: ListSectionController {

    // MARK: - Data Vars
    var pollsDateModel: PollsDateModel!
    var delegate: PollsDateAttendanceSectionControllerDelegate!

    // MARK: - Constants
    let cellHeight: CGFloat = 47

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
        cell.configure(for: pollsDateModel)
        return cell
    }

    override func didUpdate(to object: Any) {
        pollsDateModel = object as? PollsDateModel
    }

    override func didSelectItem(at index: Int) {
        
    }

}
