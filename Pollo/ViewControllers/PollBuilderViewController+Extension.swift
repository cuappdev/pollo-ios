//
//  PollBuilderViewController+Extension.swift
//  Pollo
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

extension PollBuilderViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return isKeyboardShown
    }
    
}

extension PollBuilderViewController: MCPollBuilderViewDelegate { 

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

    func loadDraft(draft: Draft) {
        mcPollBuilder.fillDraft(title: draft.text, options: draft.options)
        loadedMCDraft = draft
        updateCanDraft(true)
    }
    
}

extension PollBuilderViewController: EditDraftViewControllerDelegate {

    func editDraftViewControllerDidTapDeleteDraftButton(draft: Draft) {
        deleteDraft(with: "\(draft.id)").observe { [weak self] result in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .value(let response):
                    if response.success {
                        guard let index = self.drafts.index(where: { otherDraft -> Bool in
                            return otherDraft.id == draft.id
                        }) else { return }
                        self.drafts.remove(at: index)
                        
                        self.updatePollBuilderViews()
                    } else {
                        let alertController = self.createAlert(title: self.errorText, message: self.failedToDeleteDraftText)
                        self.present(alertController, animated: true, completion: nil)
                    }
                case .error(let error):
                    print("error: ", error)
                }
            }
        }
    }

}
