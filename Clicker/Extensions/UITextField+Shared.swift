//
//  UITextField+Shared.swift
//  Clicker
//
//  Created by Mindy Lou on 4/28/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import Foundation

extension UITextField {

    func updateTextToDisplayProfanity(for words: [String]) {
        guard let text = self.text else { return }
        let nsString = text as NSString
        let attributedString = NSMutableAttributedString(string: text)
        words.forEach {
            let range = nsString.range(of: $0)
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        }
        attributedText = attributedString
    }

}
