//
//  PollBuilderViewController+Extension.swift
//  Clicker
//
//  Created by Kevin Chan on 9/22/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation

extension PollBuilderViewController: PollBuilderViewDelegate {
    
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
            draftsButton.titleLabel?.font = ._16MediumFont
        }
    }

}

extension PollBuilderViewController: DraftsViewControllerDelegate {
    
    func draftsViewControllerShouldStartDraft(_ draft: Draft) {
        let qType: QuestionType = (draft.options == []) ? .freeResponse : .multipleChoice
        if questionType != qType {
            updateQuestionTypeButton()
            mcPollBuilder.isHidden = questionType == .freeResponse
            frPollBuilder.isHidden = questionType == .multipleChoice
        }
        switch qType {
        case .multipleChoice:
            mcPollBuilder.fillDraft(title: draft.text, options: draft.options)
            loadedMCDraft = draft
        case .freeResponse:
            frPollBuilder.questionTextField.text = draft.text
            loadedFRDraft = draft
        }
        updateCanDraft(true)
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

extension PollBuilderViewController: EditQuestionTypeDelegate {
    
    func editQuestionTypeViewControllerDidPick(questionType: QuestionType) {
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
