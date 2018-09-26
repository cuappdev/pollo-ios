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
    func draftSectionControllerDidSelectDraft(draft: Draft)
}

class DraftSectionController: ListSectionController, DraftCellDelegate {
    
    // MARK: - Data vars
    var draft: Draft!
    var delegate: DraftSectionControllerDelegate!
    
    // MARK: - Constants
    let cellHeight: CGFloat = 82
    let interitemSpacing: CGFloat = 18
    
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
        return CGSize(width: containerSize.width, height: cellHeight)
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
    
    func draftCellDidSelectDraft(draft: Draft) {
        delegate.draftSectionControllerDidSelectDraft(draft: draft)
    }
    
    override func didUpdate(to object: Any) {
        draft = object as? Draft
    }
}
