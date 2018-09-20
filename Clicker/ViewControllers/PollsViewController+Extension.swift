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
    
    func pollsCellShouldOpenSession(session: Session, userRole: UserRole) {
        GetSortedPolls(id: session.id).make()
            .done { pollsDateArray in
                let cardController = CardController(pollsDateArray: pollsDateArray, session: session, userRole: userRole)
                self.navigationController?.pushViewController(cardController, animated: true)
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            } .catch { error in
                print(error)
        }
    }
    
    func pollsCellShouldEditSession(session: Session) {
        let width = ModalSize.full
        let height = ModalSize.custom(size: editModalHeight)
        let originY = view.frame.height - CGFloat(editModalHeight)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: originY))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        let presenter = Presentr(presentationType: customType)
        presenter.backgroundOpacity = 0.6
        presenter.dismissOnSwipe = true
        presenter.dismissOnSwipeDirection = .bottom
        let editPollVC = EditPollViewController()
        editPollVC.session = session
        editPollVC.homeViewController = self
        let navigationVC = UINavigationController(rootViewController: editPollVC)
        customPresentViewController(presenter, viewController: navigationVC, animated: true, completion: nil)
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
    
}

extension PollsViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return isKeyboardShown
    }
    
}
