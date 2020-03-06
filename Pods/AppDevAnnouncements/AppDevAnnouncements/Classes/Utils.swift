//
//  Utils.swift
//  TestEnv
//
//  Created by Kevin Chan on 10/27/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class Utils {

    internal static func getTextHeight(for attributedString: NSAttributedString, withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = attributedString.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin,  context: nil)

        return ceil(boundingBox.height)
    }

    internal static func attributedString(for string: String) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let bodyAttributes = [
            NSAttributedString.Key.paragraphStyle : style,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
        ]
        let attributedStr = NSAttributedString(string: string, attributes: bodyAttributes)
        return attributedStr
    }

    internal static func getColor(hexString: String, alpha: CGFloat = 1.0) -> UIColor {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

}
