//
//  DraftsViewController+Extension.swift
//  Clicker
//
//  Created by Kevin Chan on 8/26/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import IGListKit
import Presentr

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

extension DraftsViewController: EditDraftViewControllerDelegate {
    func editDraftViewControllerDidTapEditDraftButton(draft: Draft) {
        delegate.draftsViewControllerShouldStartDraft(draft)
        self.dismiss(animated: true, completion: nil)
    }
    
    func editDraftViewControllerDidTapDeleteDraftButton(draft: Draft) {
        DeleteDraft(id: draft.id).make()
            .done {
                guard let index = self.drafts.index(where: { otherDraft -> Bool in
                    return otherDraft.id == draft.id
                }) else { return }
                self.drafts.remove(at: index)
                self.adapter.performUpdates(animated: false, completion: nil)
                
                guard let nav = self.presentingViewController as? UINavigationController else { return }
                guard let pollBuilderViewController = nav.topViewController as? PollBuilderViewController else { return }
                pollBuilderViewController.getDrafts()
            } .catch { error in
                self.alertDeleteFailed()
        }
    }
    
    func alertDeleteFailed() {
        let alertController = UIAlertController(title: "Error", message: "Failed to delete draft. Try again!", preferredStyle: .alert)
        alertController.view.tintColor = .clickerGreen0
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
            alertController.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
}

extension DraftsViewController: EmptyStateCellDelegate {
    func emptyStateCellDidTapCreateDraftButton() {
        backBtnPressed()
    }
}

extension DraftsViewController: DraftSectionControllerDelegate {
    func draftSectionControllerDidSelectDraft(draft: Draft) {
        let width = ModalSize.full
        let height = ModalSize.custom(size: Float(editDraftModalSize))
        let originY = view.bounds.height - editDraftModalSize
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: originY))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        let presenter = Presentr(presentationType: customType)
        presenter.backgroundOpacity = 0.6
        presenter.dismissOnSwipe = true
        presenter.dismissOnSwipeDirection = .bottom
        let editDraftViewController = EditDraftViewController(delegate: self, draft: draft)
        customPresentViewController(presenter, viewController: editDraftViewController, animated: true, completion: nil)
    }
}
