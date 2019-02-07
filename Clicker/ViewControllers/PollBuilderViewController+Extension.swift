//
//  PollBuilderViewController+Extension.swift
//  Clicker
//
//  Created by Kevin Chan on 9/22/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Presentr

extension PollBuilderViewController: PollBuilderViewDelegate {
    
    func ignoreNextKeyboardHiding() {
        shouldIgnoreNextKeyboardHiding = isKeyboardShown
    }
    
    func updateCanDraft(_ canDraft: Bool) {
        self.canDraft = canDraft
        if canDraft {
            saveDraftButton.setTitleColor(.clickerGreen0, for: .normal)
            saveDraftButton.backgroundColor = .clear
            saveDraftButton.layer.borderColor = UIColor.clickerGreen0.cgColor
        } else {
            saveDraftButton.setTitleColor(.clickerGrey2, for: .normal)
            saveDraftButton.backgroundColor = .clickerGrey6
            saveDraftButton.layer.borderColor = UIColor.clickerGrey6.cgColor
        }
    }
    
    func updateCorrectAnswer(correctAnswer: String?) {
        self.correctAnswer = correctAnswer
    }
}

extension PollBuilderViewController: QuestionTypeDropDownViewDelegate {
    
    func questionTypeDropDownViewDidPick(questionType: QuestionType) {
        hideDropDown()
        self.questionType = questionType
        updateQuestionTypeButton()
        mcPollBuilder.isHidden = questionType == .freeResponse
        frPollBuilder.isHidden = questionType == .multipleChoice
    }

}

extension PollBuilderViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return isKeyboardShown
    }
    
}

extension PollBuilderViewController: MCPollBuilderViewDelegate, FRPollBuilderViewDelegate {

    func shouldEditDraft(draft: Draft) {
        let width: ModalSize = .full
        let modalHeight = editDraftModalSize + view.safeAreaInsets.bottom
        let height = ModalSize.custom(size: Float(modalHeight))
        let originY = UIScreen.main.bounds.height - modalHeight
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: originY))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        let presenter = Presentr(presentationType: customType)
        presenter.backgroundOpacity = 0.6
        presenter.dismissOnSwipe = true
        presenter.dismissOnSwipeDirection = .bottom
        let editDraftViewController = EditDraftViewController(delegate: self, draft: draft)
        customPresentViewController(presenter, viewController: editDraftViewController, animated: true, completion: nil)
    }

    func shouldLoadDraft(draft: Draft) {
        let draftQuestionType: QuestionType = (draft.options == []) ? .freeResponse : .multipleChoice
        if questionType != draftQuestionType {
            mcPollBuilder.isHidden = draftQuestionType == .freeResponse
            frPollBuilder.isHidden = draftQuestionType == .multipleChoice
            questionType = draftQuestionType
            updateQuestionTypeButton()
        }
        switch draftQuestionType {
        case .multipleChoice:
            mcPollBuilder.fillDraft(title: draft.text, options: draft.options)
            loadedMCDraft = draft
        case .freeResponse:
            frPollBuilder.fillDraft(title: draft.text)
            loadedFRDraft = draft
        }
        updateCanDraft(true)
    }
    
}

extension PollBuilderViewController: EditDraftViewControllerDelegate {

    func editDraftViewControllerDidTapDeleteDraftButton(draft: Draft) {
        DeleteDraft(id: draft.id).make()
            .done {
                guard let index = self.drafts.index(where: { otherDraft -> Bool in
                    return otherDraft.id == draft.id
                }) else { return }
                self.drafts.remove(at: index)

                if let loadedFRDraft = self.loadedFRDraft, draft.isEqual(toDiffableObject: loadedFRDraft) {
                    self.loadedFRDraft = nil
                }

                self.updatePollBuilderViews()
            } .catch { error in
                let alertController = self.createAlert(title: self.errorText, message: self.failedToDeleteDraftText)
                self.present(alertController, animated: true, completion: nil)
        }
    }

}
