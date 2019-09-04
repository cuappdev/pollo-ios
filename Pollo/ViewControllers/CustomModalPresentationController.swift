//
//  PresentationController.swift
//  Pollo
//
//  Created by Matthew Coufal on 9/28/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

enum ModalStyle {
    case custom(heightScale: CGFloat)
    case upToStatusBar
}

class CustomModalPresentationController: UIPresentationController {
    
    var style: ModalStyle!
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        guard let containerView = containerView else { return .zero }
        frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView.bounds.size)
        if let style = style {
            switch style {
            case .upToStatusBar:
                frame.origin.y = UIApplication.shared.statusBarFrame.height
                break
            case .custom(let heightScale):
                frame.origin.y = containerView.bounds.height * (1.0 - heightScale)
            }
        }
        return frame
    }

    init(presented: UIViewController, presenting: UIViewController?, style: ModalStyle) {
        self.style = style
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
        var height: CGFloat = 0
        if let style = style {
            switch style {
            case .upToStatusBar:
                height = parentSize.height - UIApplication.shared.statusBarFrame.height
                break
            case .custom(let heightScale):
                height = parentSize.height * heightScale
            }
        }
        return CGSize(width: parentSize.width, height: height)
    }
    
}
