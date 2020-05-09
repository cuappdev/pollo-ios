//
//  MCResultSectionController.swift
//  Pollo
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

protocol MCResultSectionControllerDelegate: class {
    
    var userRole: UserRole { get }

}

class MCResultSectionController: ListSectionController {
    
    weak var delegate: MCResultSectionControllerDelegate!
    var resultModel: MCResultModel!
    var correctAnswer: Int?
    
    init(delegate: MCResultSectionControllerDelegate, correctAnswer: Int?) {
        self.delegate = delegate
        self.correctAnswer = correctAnswer
    }
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        let cellHeight = LayoutConstants.mcOptionCellHeight
        return CGSize(width: containerSize.width, height: cellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: MCResultCell.self, for: self, at: index) as! MCResultCell
        cell.showCorrectAnswer = false
        cell.configure(for: resultModel, userRole: delegate.userRole, correctAnswer: correctAnswer)
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    override func didUpdate(to object: Any) {
        resultModel = object as? MCResultModel
    }

    // MARK: - Updates
    func update(with resultModel: MCResultModel) {
        // Make sure to update resultModel for cells that are currently not on the screen
        // so that when they get dequeued again, they will have the correct resultModel
        self.resultModel = resultModel
        guard let cell = collectionContext?.cellForItem(at: 0, sectionController: self) as? MCResultCell else { return }
        cell.update(with: resultModel, correctAnswer: correctAnswer)
    }

}
