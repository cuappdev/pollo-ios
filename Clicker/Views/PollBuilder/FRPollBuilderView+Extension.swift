//
//  FRPollBuilderView+Extension.swift
//  Clicker
//
//  Created by Kevin Chan on 12/6/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit

extension FRPollBuilderView: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var models: [ListDiffable] = [askQuestionModel]
        if let drafts = delegate?.drafts, !drafts.isEmpty {
            draftsTitleModel = DraftsTitleModel(numDrafts: drafts.count)
            if let draftsTitleModel = draftsTitleModel {
                models.append(draftsTitleModel)
            }
            models.append(contentsOf: drafts)
        }
        return models
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is AskQuestionModel {
            return AskQuestionSectionController(delegate: self)
        } else if object is Draft {
            return DraftSectionController(delegate: self)
        } else if object is DraftsTitleModel {
            return DraftsTitleSectionController()
        }

        fatalError("Unsupported object type")
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }

}

extension FRPollBuilderView: DraftSectionControllerDelegate {

    func draftSectionControllerLoadDraft(draft: Draft) {
        delegate?.shouldLoadDraft(draft: draft)
    }

    func draftSectionControllerEditDraft(draft: Draft) {
        delegate?.shouldEditDraft(draft: draft)
    }

}

extension FRPollBuilderView: AskQuestionSectionControllerDelegate {

    func askQuestionSectionControllerDidUpdateEditable(_ editable: Bool) {
        pollBuilderDelegate?.updateCanDraft(editable)
        self.editable = editable
    }

    func askQuestionSectionControllerDidUdpateText(_ text: String?) {
        askQuestionModel.currentQuestion = text
    }

}

extension FRPollBuilderView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = IntegerConstants.maxQuestionCharacterCount
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }

}
