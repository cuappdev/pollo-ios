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
    func fillDraft(draft: Draft) {
        delegate.fillDraft(draft)
        self.dismiss(animated: true, completion: nil)
    }
}

//extension DraftsViewController {
//
//    // MARK - COLLECTION VIEW
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return drafts.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = draftsCollectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.draftCellIdentifier, for: indexPath) as! DraftCell
//        cell.configure(with: drafts[drafts.count - (indexPath.row + 1)])
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: draftsCollectionView.frame.width, height: 82.0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        delegate.fillDraft(drafts[drafts.count - (indexPath.row + 1)])
//
//        self.dismiss(animated: true, completion: nil)
//    }
//}
