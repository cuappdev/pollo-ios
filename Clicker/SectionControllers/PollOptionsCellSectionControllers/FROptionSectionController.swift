//
//  FROptionSectionController.swift
//  Clicker
//
//  Created by Kevin Chan on 9/9/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

protocol FROptionSectionControllerDelegate {
    
    var pollState: PollState { get }
    
    func frOptionSectionControllerDidUpvote(for answerId: String)
    
}

class FROptionSectionController: ListSectionController {
    
    // MARK: - Data vars
    var delegate: FROptionSectionControllerDelegate!
    var frOptionModel: FROptionModel!
    
    // MARK: - Constants
    let frOptionCellOptionLabelSize: CGFloat = 14
    let frOptionCellOptionLabelVerticalPadding: CGFloat = 19.5
    let frOptionCellOptionLabelWidthScaleFactor: CGFloat = 0.8
    
    init(delegate: FROptionSectionControllerDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        return CGSize(width: containerSize.width, height: LayoutConstants.frOptionCellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: FROptionCell.self, for: self, at: index) as! FROptionCell
        cell.configure(for: frOptionModel, delegate: self)
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    override func didUpdate(to object: Any) {
        frOptionModel = object as? FROptionModel
    }

    // MARK: - Updates
    func update(with frOptionModel: FROptionModel) {
        // Make sure to update frOptionModel for cells that are currently not on the screen
        // so that when they get dequeued again, they will have the correct resultModel
        self.frOptionModel = frOptionModel
        guard let cell = collectionContext?.cellForItem(at: 0, sectionController: self) as? FROptionCell else { return }
        cell.update(with: frOptionModel)
    }

}

extension FROptionSectionController: FROptionCellDelegate {

    func frOptionCellDidReceiveUpvote(for answerId: String) {
        delegate.frOptionSectionControllerDidUpvote(for: answerId)
    }
    
}
