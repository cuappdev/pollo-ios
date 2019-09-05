//
//  UINavigationController+Extension.swift
//  Pollo
//
//  Created by eoin on 10/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return visibleViewController
    }
}
