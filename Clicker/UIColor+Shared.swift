//
//  UIColor+Shared.swift
//  Clicker
//
//  Created by Keivan Shahida on 11/5/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

extension UIColor {
    //    UIColor.colorFromCode(0xA23A40).withAlphaComponent(0.26)
    
    @nonobjc static let clickerBlue = UIColor.colorFromCode(0x4EA0FF)
    @nonobjc static let clickerLightGray = UIColor.colorFromCode(0xE8E8E8)
    @nonobjc static let clickerMediumGray = UIColor.colorFromCode(0x969BA6)
    @nonobjc static let clickerDarkGray = UIColor.colorFromCode(0x80868D)
    @nonobjc static let clickerBackground = UIColor.colorFromCode(0xF7F9FA)
    @nonobjc static let clickerBorder = UIColor.colorFromCode(0xE1E1E1)
    @nonobjc static let clickerRed = UIColor.colorFromCode(0xFF8B8B)


    public static func colorFromCode(_ code: Int) -> UIColor {
        let red = CGFloat(((code & 0xFF0000) >> 16)) / 255
        let green = CGFloat(((code & 0xFF00) >> 8)) / 255
        let blue = CGFloat((code & 0xFF)) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}

