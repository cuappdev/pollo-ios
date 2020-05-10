//
//  UITextField+Shared.swift
//  Pollo
//
//  Created by Mindy Lou on 4/28/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {

    func updateTextToDisplayProfanity(for words: [String], in text: String) {
        let nsString = text as NSString
        let attributedString = NSMutableAttributedString(string: text)
        words.forEach {
            let range = nsString.range(of: $0)
            attributedString.addAttribute(.foregroundColor, value: UIColor.clickerRed, range: range)
        }
        attributedText = attributedString
    }

}
