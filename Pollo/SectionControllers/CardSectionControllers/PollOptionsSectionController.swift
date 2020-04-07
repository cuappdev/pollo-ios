//
//  PollOptionsModel.swift
//  Pollo
//
//  Created by Kevin Chan on 9/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

protocol PollOptionsSectionControllerDelegate {
    
    var isConnected: Bool { get }
    var maxCellHeight: CGFloat { get }
    var userRole: UserRole { get }
    
    func pollOptionsSectionControllerDidSubmitChoice(sectionController: PollOptionsSectionController, choice: String, index: Int?)
    
}

class PollOptionsSectionController: ListSectionController {
    
    // MARK: - Data vars
    var correctAnswer: Int?
    var delegate: PollOptionsSectionControllerDelegate!
    var pollOptionsModel: PollOptionsModel!
    
    init(delegate: PollOptionsSectionControllerDelegate, correctAnswer: Int?) {
        self.correctAnswer = correctAnswer
        self.delegate = delegate
    }
    
    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        let calculatedCellHeight = calculatePollOptionsCellHeight(for: pollOptionsModel)
        let cellHeight = min(delegate.maxCellHeight, calculatedCellHeight)
        return CGSize(width: containerSize.width, height: cellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: PollOptionsCell.self, for: self, at: index) as! PollOptionsCell
        cell.configure(for: pollOptionsModel, delegate: self, correctAnswer: correctAnswer, maxCellHeight: delegate.maxCellHeight)
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

    var isConnected: Bool {
        return delegate.isConnected
    }

    func pollOptionsCellDidSubmitChoice(choice: String, index: Int) {
        delegate.pollOptionsSectionControllerDidSubmitChoice(sectionController: self, choice: choice, index: index)
    }
    
}
