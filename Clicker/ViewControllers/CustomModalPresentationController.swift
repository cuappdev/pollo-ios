//
//  PresentationController.swift
//  Clicker
//
//  Created by Matthew Coufal on 9/28/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class CustomModalPresentationController: UIPresentationController {
    
    var customHeightScaleFactor: CGFloat!
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        guard let containerView = containerView else { return .zero }
        frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView.bounds.size)
        frame.origin.y = containerView.bounds.height * (1.0 - customHeightScaleFactor)
        return frame
    }

    init(presented: UIViewController, presenting: UIViewController?, customHeightScaleFactor: CGFloat) {
        self.customHeightScaleFactor = customHeightScaleFactor
        super.init(presentedViewController: presented, presenting: presenting)
    }
    
    override func presentationTransitionWillBegin() {
        presentingViewController.view.alpha = 0.5
    }
    
    override func dismissalTransitionWillBegin() {
        presentingViewController.view.alpha = 1.0
    }
    
    override func containerViewWillLayoutSubviews() {
        guard let presentedView = presentedView else { return }
        presentedView.frame = frameOfPresentedViewInContainerView
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width, height: parentSize.height * customHeightScaleFactor)
    }
    
}
