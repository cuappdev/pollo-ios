//
//  DraftsViewController+Extension.swift
//  Clicker
//
//  Created by Kevin Chan on 8/26/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import IGListKit

extension DraftsViewController: DraftCellDelegate {
    func draftCellDidSelectDraft(draft: Draft) {
        self.delegate.fillDraft(draft)
    }
}

extension DraftsViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return drafts
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return DraftSectionController(delegate: self)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension DraftsViewController: DraftSectionControllerDelegate {
    func draftSectionControllerDidFillDraft(draft: Draft) {
        delegate.fillDraft(draft)
        self.dismiss(animated: true, completion: nil)
    }
}
