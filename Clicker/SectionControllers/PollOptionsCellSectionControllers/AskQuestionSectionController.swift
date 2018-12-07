//
//  AskQuestionSectionController.swift
//  Clicker
//
//  Created by Kevin Chan on 12/6/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

protocol AskQuestionSectionControllerDelegate {
    func askQuestionSectionControllerDidUpdateEditable(_ editable: Bool)
    func askQuestionSectionControllerDidUdpateText(_ text: String?)
}

class AskQuestionSectionController: ListSectionController {

    // MARK: - Data vars
    var delegate: AskQuestionSectionControllerDelegate?
    var askQuestionModel: AskQuestionModel!

    // MARK: - Constants
    let cellHeight: CGFloat = 48

    // MARK: - Init
    init(delegate: AskQuestionSectionControllerDelegate) {
        self.delegate = delegate
    }

    // MARK: - ListSectionController overrides
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else {
            return .zero
        }
        return CGSize(width: containerSize.width, height: cellHeight)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: AskQuestionCell.self, for: self, at: index) as! AskQuestionCell
        cell.configure(with: self, askQuestionModel: askQuestionModel)
        return cell
    }

    override func didUpdate(to object: Any) {
        askQuestionModel = object as? AskQuestionModel
    }

    // MARK: - Public API
    func getTextFieldText() -> String? {
        guard let cell = collectionContext?.cellForItem(at: 0, sectionController: self) as? AskQuestionCell else {
            return nil
        }
        return cell.textField.text
    }

}

extension AskQuestionSectionController: AskQuestionCellDelegate {

    func askQuestionCellDidUpdateEditable(_ editable: Bool) {
        delegate?.askQuestionSectionControllerDidUpdateEditable(editable)
    }

    func askQuestionCellDidUdpateText(_ text: String?) {
        delegate?.askQuestionSectionControllerDidUdpateText(text)
    }

}
