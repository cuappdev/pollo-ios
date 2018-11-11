//
//  ViewAllSectionController.swift
//  Clicker
//
//  Created by Kevin Chan on 11/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

protocol ViewAllSectionControllerDelegate {
    func viewAllSectionControllerWasTapped()
}

class ViewAllSectionController: ListSectionController {

    // MARK: - Data vars
    var viewAllModel: ViewAllModel!
    var delegate: ViewAllSectionControllerDelegate?

    // MARK: - Constants
    let cellHeight: CGFloat = 31

    init(delegate: ViewAllSectionControllerDelegate) {
        self.delegate = delegate
    }

    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        return CGSize(width: containerSize.width, height: cellHeight)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: ViewAllCell.self, for: self, at: index) as! ViewAllCell
        return cell
    }

    override func didUpdate(to object: Any) {
        self.viewAllModel = object as? ViewAllModel
    }

    override func didSelectItem(at index: Int) {
        delegate?.viewAllSectionControllerWasTapped()
    }

    override func didDeselectItem(at index: Int) {
        delegate?.viewAllSectionControllerWasTapped()
    }
}
