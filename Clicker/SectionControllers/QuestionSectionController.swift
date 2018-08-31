//
//  QuestionSectionController.swift
//  Clicker
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

class QuestionSectionController: ListSectionController {
    
    var questionModel: QuestionModel!
    let cellHeight: CGFloat = 62
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        return CGSize(width: containerSize.width, height: cellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: QuestionCell.self, for: self, at: index) as! QuestionCell
        cell.configure(for: questionModel)
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    override func didUpdate(to object: Any) {
        questionModel = object as? QuestionModel
    }
    
}
