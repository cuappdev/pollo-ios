//
//  DraftSectionController.swift
//  Clicker
//
//  Created by Matthew Coufal on 9/21/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import IGListKit

protocol DraftSectionControllerDelegate {
    func draftSectionControllerLoadDraft(draft: Draft)
    func draftSectionControllerEditDraft(draft: Draft)
}

class DraftSectionController: ListSectionController, DraftCellDelegate {
    
    // MARK: - Data vars
    var draft: Draft!
    var delegate: DraftSectionControllerDelegate!
    
    // MARK: - Constants
    let interitemSpacing: CGFloat = 18
    let constrainedTextWidth: CGFloat = 253
    
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
        let textHeight = draft.text.height(withConstrainedWidth: constrainedTextWidth, font: ._18HeavyFont)
        return CGSize(width: containerSize.width, height: textHeight + 65)
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
        delegate.draftSectionControllerEditDraft(draft: draft)
    }
    
    func draftCellDidTapLoadButton(draft: Draft) {
        delegate.draftSectionControllerLoadDraft(draft: draft)
    }
    
    override func didUpdate(to object: Any) {
        draft = object as? Draft
    }
}
