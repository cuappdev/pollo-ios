//
//  DraftSectionController.swift
//  Pollo
//
//  Created by Matthew Coufal on 9/21/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import IGListKit

protocol DraftSectionControllerDelegate: class {
    func draftSectionControllerLoadDraft(draft: Draft)
    func draftSectionControllerEditDraft(draft: Draft)
}

class DraftSectionController: ListSectionController, DraftCellDelegate {

    // MARK: - Data vars
    var draft: Draft!
    weak var delegate: DraftSectionControllerDelegate?
    
    // MARK: - Constants
    let constrainedTextWidth: CGFloat = 253
    let interitemSpacing: CGFloat = 18
    let maxDraftTextHeight: CGFloat = 130
    
    init(delegate: DraftSectionControllerDelegate) {
        super.init()
        self.delegate = delegate
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: interitemSpacing, right: 0)
    }
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        let calculatedTextHeight = draft.text.height(withConstrainedWidth: constrainedTextWidth, font: ._18HeavyFont)
        let adjustedTextHeight = calculatedTextHeight + 65 // 65 being the total padding + questionType height
        let textHeight = (adjustedTextHeight > maxDraftTextHeight) ? maxDraftTextHeight : adjustedTextHeight
        return CGSize(width: containerSize.width, height: textHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let draft = draft else {
            return UICollectionViewCell()
        }
        let cell = collectionContext?.dequeueReusableCell(of: DraftCell.self, for: self, at: index) as! DraftCell
        cell.delegate = self
        cell.configure(with: draft)
        return cell
    }
    
    func draftCellDidTapEditButton(draft: Draft) {
        delegate?.draftSectionControllerEditDraft(draft: draft)
    }
    
    func draftCellDidTapLoadButton(draft: Draft) {
        delegate?.draftSectionControllerLoadDraft(draft: draft)
    }
    
    override func didUpdate(to object: Any) {
        draft = object as? Draft
    }
}
