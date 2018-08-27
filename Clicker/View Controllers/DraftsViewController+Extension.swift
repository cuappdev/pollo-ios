//
//  DraftsViewController+Extension.swift
//  Clicker
//
//  Created by Kevin Chan on 8/26/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

extension DraftsViewController {
    
    // MARK - COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drafts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = draftsCollectionView.dequeueReusableCell(withReuseIdentifier: "draftCellID", for: indexPath) as! DraftCell
        cell.draft = drafts[drafts.count - (indexPath.row + 1)]
        cell.setupCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: draftsCollectionView.frame.width, height: 82.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.fillDraft(drafts[drafts.count - (indexPath.row + 1)])
        
        self.dismiss(animated: true, completion: nil)
    }
}
