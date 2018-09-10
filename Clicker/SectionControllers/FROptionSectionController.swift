//
//  FROptionSectionController.swift
//  Clicker
//
//  Created by Kevin Chan on 9/9/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

protocol FROptionSectionControllerDelegate {
    
    var cardControllerState: CardControllerState { get }
    var pollState: PollState { get }
    
    func frOptionSectionControllerDidUpvote(sectionController: FROptionSectionController)
    
}

class FROptionSectionController: ListSectionController {
    
    // MARK: - Data vars
    var delegate: FROptionSectionControllerDelegate!
    var frOptionModel: FROptionModel!
    
    // MARK: - Constants
    let frOptionCellOptionLabelVerticalPadding: CGFloat = 19.5
    let frOptionCellOptionLabelWidthScaleFactor: CGFloat = 0.8
    let frOptionCellOptionLabelSize: CGFloat = 14
    
    init(delegate: FROptionSectionControllerDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        let cellHeight = calculateFROptionCellHeight(for: frOptionModel)
        return CGSize(width: containerSize.width, height: cellHeight)
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
    
    // MARK: - Helpers
    private func calculateFROptionCellHeight(for frOptionModel: FROptionModel) -> CGFloat {
        guard let containerSize = collectionContext?.containerSize else { return 0 }
        let optionLabelWidth = containerSize.width * frOptionCellOptionLabelWidthScaleFactor
        let optionLabelHeight = frOptionModel.option.height(withConstrainedWidth: optionLabelWidth, font: .systemFont(ofSize: frOptionCellOptionLabelSize, weight: .medium))
        return optionLabelHeight + frOptionCellOptionLabelVerticalPadding * 2
    }
}

extension FROptionSectionController: FROptionCellDelegate {
    
    func frOptionCellDidReceiveUpvote() {
        delegate.frOptionSectionControllerDidUpvote(sectionController: self)
    }
    
}
