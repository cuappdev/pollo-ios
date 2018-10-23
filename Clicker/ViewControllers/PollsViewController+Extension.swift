//
//  PollsViewController+Extension.swift
//  Clicker
//
//  Created by Kevin Chan on 8/26/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import IGListKit
import Presentr
import UIKit


extension PollsViewController: ListAdapterDataSource, PollTypeSectionControllerDelegate {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return pollTypeModels
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return PollTypeSectionController(delegate: self)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    // MARK: - PollTypeSectionControllerDelegate
    var pollsCellDelegate: PollsCellDelegate {
        return self
    }
    
    func sectionControllerWillDisplayPollType(sectionController: PollTypeSectionController, pollType: PollType) {
        let item = pollType == .created ? 0 : 1
        let indexPath: IndexPath = IndexPath(item: item, section: 0)
        pollsOptionsView.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
    }
}

extension PollsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pollsOptionsView.sliderBarLeftConstraint.constant = scrollView.contentOffset.x / 2
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        pollsOptionsView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
}

extension PollsViewController: PollsCellDelegate {
    
    func pollsCellShouldOpenSession(session: Session, userRole: UserRole, withCell: PollPreviewCell) {
        if isOpeningGroup {
            return
        }
        isOpeningGroup = true
        JoinSessionWithIdAndCode(id: session.id, code: session.code).make()
            .done { session in
                GetSortedPolls(id: session.id).make()
                    .done { pollsDateArray in
                        let pollsDateViewController = PollsDateViewController(delegate: self, pollsDateArray: pollsDateArray, session: session, userRole: userRole)
                        self.navigationController?.pushViewController(pollsDateViewController, animated: true)
                        self.navigationController?.setNavigationBarHidden(false, animated: true)
                        withCell.hideOpenSessionActivityIndicatorView()
                        self.isOpeningGroup = false
                    } .catch { error in
                        print(error)
                        let alertController = self.createAlert(title: self.errorText, message: "Failed to join session. Try again!")
                        self.present(alertController, animated: true, completion: nil)
                        self.isOpeningGroup = false
                }
            } .catch { error in
                print(error)
                let alertController = self.createAlert(title: self.errorText, message: "Failed to join session. Try again!")
                self.present(alertController, animated: true, completion: nil)
                self.isOpeningGroup = false
        }
    }
    
    func pollsCellShouldEditSession(session: Session, userRole: UserRole) {
        let width = ModalSize.full
        let modalHeight = editModalHeight + view.safeAreaInsets.bottom
        let height = ModalSize.custom(size: Float(modalHeight))
        let originY = view.frame.height - modalHeight
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: originY))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        let presenter = Presentr(presentationType: customType)
        presenter.backgroundOpacity = 0.6
        presenter.dismissOnSwipe = true
        presenter.dismissOnSwipeDirection = .bottom
        let editPollVC = EditPollViewController(delegate: self, session: session, userRole: userRole)
        let navigationVC = UINavigationController(rootViewController: editPollVC)
        customPresentViewController(presenter, viewController: navigationVC, animated: true, completion: nil)
    }

    func pollsCellDidPullToRefresh(for pollType: PollType) {
        let userRole: UserRole = pollType == .joined ? .member : .admin
        reloadSessions(for: userRole) { sessions in
            let index = userRole == .admin ? 1 : 0
            self.pollTypeModels[index].sessions = sessions
            guard let pollTypeSectionController = self.adapter.sectionController(forSection: index) as? PollTypeSectionController else { return }
            pollTypeSectionController.update(with: sessions)
        }
    }
    
}

extension PollsViewController: EditPollViewControllerDelegate {
    
    func editPollViewControllerDidUpdateName(for userRole: UserRole) {
        reloadSessions(for: userRole) { sessions in
            let pollType: PollType = userRole == .admin ? .created : .joined
            let index = userRole == .admin ? 1 : 0
            self.pollTypeModels[index] = PollTypeModel(pollType: pollType, sessions: sessions)
            DispatchQueue.main.async {
                self.adapter.performUpdates(animated: true, completion: nil)
            }
        }
    }
    
    func editPollViewControllerDidDeleteSession(for userRole: UserRole) {
        reloadSessions(for: userRole) { sessions in
            let pollType: PollType = userRole == .admin ? .created : .joined
            let index = userRole == .admin ? 1 : 0
            self.pollTypeModels[index] = PollTypeModel(pollType: pollType, sessions: sessions)
            DispatchQueue.main.async {
                self.adapter.performUpdates(animated: true, completion: nil)
            }
        }
    }
    
}

extension PollsViewController: SliderBarDelegate {
    
    func scrollToIndex(index: Int) {
        let indexPath = IndexPath(item: 0, section: index)
        pollsCollectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }

}

extension PollsViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 6
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
}

extension PollsViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return isKeyboardShown
    }
    
}

extension PollsViewController: PollsDateViewControllerDelegate {

    func pollsDateViewControllerWasPopped(for userRole: UserRole) {
        reloadSessions(for: userRole) { sessions in
            let index = userRole == .admin ? 1 : 0
            self.pollTypeModels[index].sessions = sessions
            guard let pollTypeSectionController = self.adapter.sectionController(forSection: index) as? PollTypeSectionController else { return }
            pollTypeSectionController.update(with: sessions)
        }
    }

}
