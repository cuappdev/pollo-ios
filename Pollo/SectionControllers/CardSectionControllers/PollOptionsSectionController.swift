//
//  PollOptionsModel.swift
//  Pollo
//
//  Created by Kevin Chan on 9/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

protocol PollOptionsSectionControllerDelegate {
    
    var userRole: UserRole { get }
    
    func pollOptionsSectionControllerDidSubmitChoice(sectionController: PollOptionsSectionController, choice: String, index: Int?)
    
}

class PollOptionsSectionController: ListSectionController {
    
    // MARK: - Data vars
    var correctAnswer: String?
    var delegate: PollOptionsSectionControllerDelegate!
    var pollOptionsModel: PollOptionsModel!
    
    init(delegate: PollOptionsSectionControllerDelegate, correctAnswer: String?) {
        self.correctAnswer = correctAnswer
        self.delegate = delegate
    }
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        let cellHeight = calculatePollOptionsCellHeight(for: pollOptionsModel, userRole: delegate.userRole)
        return CGSize(width: containerSize.width, height: cellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: PollOptionsCell.self, for: self, at: index) as! PollOptionsCell
        cell.configure(for: pollOptionsModel, delegate: self, correctAnswer: correctAnswer)
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    override func didUpdate(to object: Any) {
        pollOptionsModel = object as? PollOptionsModel
    }

    // MARK: - Updates
    func update(with pollOptionsModelType: PollOptionsModelType) {
        guard let cell = collectionContext?.cellForItem(at: 0, sectionController: self) as? PollOptionsCell else { return }
        cell.update(with: pollOptionsModelType, correctAnswer: correctAnswer)
    }
    
}

extension PollOptionsSectionController: PollOptionsCellDelegate {
    
    var userRole: UserRole {
        return delegate.userRole
    }

    func pollOptionsCellDidSubmitChoice(choice: String, index: Int) {
        delegate.pollOptionsSectionControllerDidSubmitChoice(sectionController: self, choice: choice, index: index)
    }
    
}
