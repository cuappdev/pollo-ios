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
        self.delegate.draftsViewControllerShouldStartDraft(draft)
    }
}

extension DraftsViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return drafts.count > 0 ? drafts : [EmptyStateModel(type: .draftsViewController(delegate: self))]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is Draft {
            return DraftSectionController(delegate: self)
        }
        return EmptyStateSectionController(session: nil, shouldDisplayNameView: false, nameViewDelegate: nil)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension DraftsViewController: EmptyStateCellDelegate {
    func emptyStateCellDidTapCreateDraftButton() {
        backBtnPressed()
    }
}

extension DraftsViewController: DraftSectionControllerDelegate {
    func draftSectionControllerDidFillDraft(draft: Draft) {
        delegate.draftsViewControllerShouldStartDraft(draft)
        self.dismiss(animated: true, completion: nil)
    }
}
