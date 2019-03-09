//
//  MCPollBuilderView+Extension.swift
//  Clicker
//
//  Created by Kevin Chan on 12/6/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit
import Presentr

extension MCPollBuilderView: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var models: [ListDiffable] = [askQuestionModel]
        models.append(contentsOf: mcOptionModels)
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
        if object is PollBuilderMCOptionModel {
            return PollBuilderMCOptionSectionController(delegate: self)
        } else if object is AskQuestionModel {
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

extension MCPollBuilderView: PollBuilderMCOptionSectionControllerDelegate {

    func pollBuilderSectionControllerShouldAddOption() {
        if mcOptionModels.count >= 27 { return }
        let newMCOptionModel = PollBuilderMCOptionModel(type: .newOption(option: "", index: mcOptionModels.count - 1, isCorrect: false))
        mcOptionModels.insert(newMCOptionModel, at: mcOptionModels.count - 1)
        updateTotalOptions()
        pollBuilderDelegate?.ignoreNextKeyboardHiding()
        adapter.reloadData { _ in
            // -1 because first cell is AskQuestionCell, then CreateMCOptionCells
            let index = IndexPath(item: 0, section: self.mcOptionModels.count - 1)
            self.collectionView.scrollToItem(at: index, at: .centeredVertically, animated: true)
            guard let cell = self.collectionView.cellForItem(at: index) as? CreateMCOptionCell else {
                print("thats not the right type of cell, something went wrong")
                return
            }
            cell.shouldFocusTextField()
        }
    }

    func pollBuilderSectionControllerDidUpdateOption(option: String, index: Int, isCorrect: Bool) {
        mcOptionModels[index].type = .newOption(option: option, index: index, isCorrect: isCorrect)
    }

    func pollBuilderSectionControllerDidUpdateIsCorrect(option: String, index: Int, isCorrect: Bool) {
        pollBuilderDelegate?.updateCorrectAnswer(correctAnswer: isCorrect ? intToMCOption(index) : nil)
        if isCorrect {
            var updatedMCOptionModels: [PollBuilderMCOptionModel] = []
            mcOptionModels.enumerated().forEach { (index, mcOptionModel) in
                switch mcOptionModel.type {
                case .newOption(option: let option, index: _, isCorrect: let isCorrect):
                    if isCorrect {
                        updatedMCOptionModels.append(PollBuilderMCOptionModel(type: .newOption(option: option, index: index, isCorrect: false)))
                    } else {
                        updatedMCOptionModels.append(mcOptionModel)
                    }
                case .addOption:
                    updatedMCOptionModels.append(mcOptionModel)
                }
            }
            mcOptionModels = updatedMCOptionModels
        }
        mcOptionModels[index] = PollBuilderMCOptionModel(type: .newOption(option: option, index: index, isCorrect: isCorrect))
        updateTotalOptions()
        adapter.performUpdates(animated: false, completion: nil)
    }

    func pollBuilderSectionControllerDidDeleteOption(index: Int) {
        if mcOptionModels.count <= 3 { return }
        mcOptionModels.remove(at: index)
        var updatedMCOptionModels: [PollBuilderMCOptionModel] = []
        mcOptionModels.enumerated().forEach { (index, mcOptionModel) in
            switch mcOptionModel.type {
            case .newOption(option: let option, index: _, isCorrect: let isCorrect):
                updatedMCOptionModels.append(PollBuilderMCOptionModel(type: .newOption(option: option, index: index, isCorrect: isCorrect)))
            case .addOption:
                updatedMCOptionModels.append(mcOptionModel)
            }
        }
        mcOptionModels = updatedMCOptionModels
        updateTotalOptions()
        pollBuilderDelegate?.ignoreNextKeyboardHiding()

        adapter.performUpdates(animated: true) { _ in
            if self.pollBuilderDelegate?.isKeyboardShown == true {
                // if deleted last option, select new last option. else, select new option at index of deleted option
                let newIndex = index == self.mcOptionModels.count - 1 ? self.mcOptionModels.count - 2 : index
                let selectIndex = IndexPath(item: 0, section: newIndex)
                self.collectionView.scrollToItem(at: selectIndex, at: .centeredVertically, animated: true)
                guard let cell = self.collectionView.cellForItem(at: selectIndex) as? CreateMCOptionCell else {
                    print("thats not the right type of cell, something went wrong")
                    return
                }
                cell.shouldFocusTextField()
            }
        }
    }

}

extension MCPollBuilderView: DraftSectionControllerDelegate {

    func draftSectionControllerLoadDraft(draft: Draft) {
        delegate?.shouldLoadDraft(draft: draft)
    }

    func draftSectionControllerEditDraft(draft: Draft) {
        delegate?.shouldEditDraft(draft: draft)
    }

}

extension MCPollBuilderView: AskQuestionSectionControllerDelegate {

    func askQuestionSectionControllerDidUpdateEditable(_ editable: Bool) {
        pollBuilderDelegate?.updateCanDraft(editable)
        self.editable = editable
    }

    func askQuestionSectionControllerDidUpdateText(_ text: String?) {
        askQuestionModel.currentQuestion = text
    }

}

extension MCPollBuilderView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = IntegerConstants.maxQuestionCharacterCount
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }

}

extension MCPollBuilderView: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return pollBuilderDelegate?.isKeyboardShown ?? false
    }

}
