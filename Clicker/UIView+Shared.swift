//
//  UIView+Shared.swift
//  Clicker
//
//  Created by Kevin Chan on 2/19/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

extension UIView {
    
    func intToMCOption(_ intOption: Int) -> String {
        return String(Character(UnicodeScalar(intOption + Int(("A" as UnicodeScalar).value))!))
    }
}
