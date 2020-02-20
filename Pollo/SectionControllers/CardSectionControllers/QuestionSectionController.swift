//
//  QuestionSectionController.swift
//  Pollo
//
//  Created by Kevin Chan on 8/31/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

protocol QuestionSectionControllerDelegate: class {
    func questionSectionControllerDidEditPoll(_ controller: QuestionSectionController)
}

class QuestionSectionController: ListSectionController {
    
    // MARK: - Data vars
    var questionModel: QuestionModel!
    var userRole: UserRole!
    weak var delegate: QuestionSectionControllerDelegate?
    
    // MARK: - Constants
    let questionLabelVerticalPadding: CGFloat = 10
    
    init(delegate: QuestionSectionControllerDelegate, userRole: UserRole) {
        self.delegate = delegate
        self.userRole = userRole
    }
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        var questionLabelWidth = containerSize.width - LayoutConstants.cardHorizontalPadding * 2
        if userRole == .admin {
            questionLabelWidth -= LayoutConstants.moreButtonWidth
        }
        let cellHeight = questionModel.question.height(withConstrainedWidth: questionLabelWidth, font: ._20BoldFont)// + questionLabelVerticalPadding
        return CGSize(width: containerSize.width, height: cellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: QuestionCell.self, for: self, at: index) as! QuestionCell
        cell.configure(for: questionModel, userRole: userRole)
        cell.delegate = self
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    override func didUpdate(to object: Any) {
        questionModel = object as? QuestionModel
    }
    
}

// MARK: - QuestionCellDelegate
extension QuestionSectionController: QuestionCellDelegate {

    func questionCellEditButtonPressed() {
        delegate?.questionSectionControllerDidEditPoll(self)
    }

}
