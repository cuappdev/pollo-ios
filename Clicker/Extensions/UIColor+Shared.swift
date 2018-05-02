//
//  UIColor+Shared.swift
//  Clicker
//
//  Created by Keivan Shahida on 11/5/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//
import UIKit

extension UIColor {
    
    @nonobjc static let clickerBackground = UIColor(red: 247/255, green: 249/255, blue: 250/255, alpha: 1.0)
    @nonobjc static let clickerBorder = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0)
    @nonobjc static let clickerLightGray = UIColor(red: 229/255, green: 231/255, blue: 237/255, alpha: 1.0)
    @nonobjc static let clickerMediumGray = UIColor(red: 158/255, green: 167/255, blue: 179/255, alpha: 1.0)
    @nonobjc static let clickerDarkGray = UIColor(red: 122/255, green: 129/255, blue: 139/255, alpha: 1.0)
    @nonobjc static let clickerBlack = UIColor(red: 31/255, green: 44/255, blue: 56/255, alpha: 1.0)
    @nonobjc static let clickerDeepBlack = UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 1.0)
    @nonobjc static let clicker77Black = UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 0.85)
    @nonobjc static let clickerLightBlue = UIColor(red: 220/255, green: 238/255, blue: 252/255, alpha: 1.0)
    @nonobjc static let clickerBlue = UIColor(red: 73/255, green: 157/255, blue: 255/255, alpha: 1.0)
    @nonobjc static let clickerGreen = UIColor(red: 41/255, green: 192/255, blue: 158/255, alpha: 1.0)
    @nonobjc static let clickerHalfGreen = UIColor(red: 41/255, green: 192/255, blue: 158/255, alpha: 0.5)
    @nonobjc static let clickerMint = UIColor(red: 6/255, green: 184/255, blue: 158/255, alpha: 0.19)
    @nonobjc static let clickerOrange = UIColor(red: 243/255, green: 132/255, blue: 82/255, alpha: 1.0)
    @nonobjc static let clickerOptionGrey = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    @nonobjc static let clickerNavBarGrey = UIColor(red: 246/255, green: 246/255, blue: 248/255, alpha: 1.0)
    @nonobjc static let clickerNavBarLightGrey = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
    @nonobjc static let clickerRed = UIColor(red: 249/255, green: 93/255, blue: 93/255, alpha: 1.0)
    @nonobjc static let clickerWhite = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)

    
    
    public static func colorFromCode(_ code: Int) -> UIColor {
        let red = CGFloat(((code & 0xFF0000) >> 16)) / 255
        let green = CGFloat(((code & 0xFF00) >> 8)) / 255
        let blue = CGFloat((code & 0xFF)) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
