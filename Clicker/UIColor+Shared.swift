//
//  UIColor+Shared.swift
//  Clicker
//
//  Created by Keivan Shahida on 11/5/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

extension UIColor {
    
    @nonobjc static let clickerBlue = UIColor.colorFromCode(0x4EA0FF)
    @nonobjc static let clickerBackground = UIColor(red: 247/255, green: 249/255, blue: 250/255, alpha: 1.0)
    @nonobjc static let clickerGreen = UIColor(red: 41/255, green: 192/255, blue: 158/255, alpha: 1.0)
    @nonobjc static let clickerMediumGray = UIColor(red: 229/255, green: 231/255, blue: 237/255, alpha: 1.0)
    @nonobjc static let clickerDarkGray = UIColor(red: 158/255, green: 167/255, blue: 179/255, alpha: 1.0)

    public static func colorFromCode(_ code: Int) -> UIColor {
        let red = CGFloat(((code & 0xFF0000) >> 16)) / 255
        let green = CGFloat(((code & 0xFF00) >> 8)) / 255
        let blue = CGFloat((code & 0xFF)) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
