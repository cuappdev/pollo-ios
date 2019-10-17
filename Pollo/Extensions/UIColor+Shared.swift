//
//  UIColor+Shared.swift
//  Pollo
//
//  Created by Keivan Shahida on 11/5/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//
import UIKit

extension UIColor {

    @nonobjc static let aquaMarine = UIColor(red: 66/255, green: 219/255, blue: 197/255, alpha: 1.0)
    @nonobjc static let bluishGreen = UIColor(red: 10/255, green: 161/255, blue: 127/255, alpha: 1.0)
    @nonobjc static let charcoalGrey = UIColor(red: 48.0 / 255.0, green: 48.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)
    @nonobjc static let clickerBlack0 = UIColor(red: 31/255, green: 44/255, blue: 56/255, alpha: 1.0)
    @nonobjc static let clickerBlack1 = UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 1.0)
    @nonobjc static let clickerBlack2 = UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 0.70)
    @nonobjc static let clickerBlack3 = UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 0.60)
    @nonobjc static let clickerBlue = UIColor(red: 73/255, green: 157/255, blue: 255/255, alpha: 1.0)
    @nonobjc static let clickerGreen0 = UIColor(red: 0.16, green: 0.75, blue: 0.62, alpha: 1.0)
    @nonobjc static let clickerGreen1 = UIColor(red: 41/255, green: 192/255, blue: 158/255, alpha: 0.25)
    @nonobjc static let clickerGreen2 = UIColor(red: 6/255, green: 184/255, blue: 158/255, alpha: 0.19)
    @nonobjc static let clickerGrey0 = UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 1.0)
    @nonobjc static let clickerGrey1 = UIColor(red: 229/255, green: 231/255, blue: 237/255, alpha: 1.0)
    @nonobjc static let clickerGrey10 = UIColor(red: 61/255, green: 61/255, blue: 61/255, alpha: 1.0)
    @nonobjc static let clickerGrey11 = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1.0)
    @nonobjc static let clickerGrey12 = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1.0)
    @nonobjc static let clickerGrey13 = UIColor(red: 169/255, green: 177/255, blue: 189/255, alpha: 1.0)
    @nonobjc static let clickerGrey14 = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1.0)
    @nonobjc static let clickerGrey2 = UIColor(red: 158/255, green: 167/255, blue: 179/255, alpha: 1.0)
    @nonobjc static let clickerGrey3 = UIColor(red: 122/255, green: 129/255, blue: 139/255, alpha: 1.0)
    @nonobjc static let clickerGrey4 = UIColor(red: 247/255, green: 249/255, blue: 250/255, alpha: 1.0)
    @nonobjc static let clickerGrey5 = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0)
    @nonobjc static let clickerGrey6 = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    @nonobjc static let clickerGrey7 = UIColor(red: 246/255, green: 246/255, blue: 248/255, alpha: 1.0)
    @nonobjc static let clickerGrey8 = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
    @nonobjc static let clickerGrey9 = UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 0.6)
    @nonobjc static let clickerOrange = UIColor(red: 243/255, green: 132/255, blue: 82/255, alpha: 1.0)
    @nonobjc static let clickerRed = UIColor(red: 0.91, green: 0.39, blue: 0.4, alpha: 1.0)
    @nonobjc static let clickerWhite = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
    @nonobjc static let clickerWhite2 = UIColor(white: 234.0 / 255.0, alpha: 0.5)
    @nonobjc static let grapefruit = UIColor(red: 249.0 / 255.0, green: 93.0 / 255.0, blue: 93.0 / 255.0, alpha: 1.0)
    @nonobjc static let coolGray = UIColor(red: 159.0 / 255.0, green: 165.0 / 255.0, blue: 177.0 / 255.0, alpha: 1.0)
    @nonobjc static let mediumGray = UIColor(white: 108.0 / 255.0, alpha: 1.0)

    public static func colorFromCode(_ code: Int) -> UIColor {
        let red = CGFloat(((code & 0xFF0000) >> 16)) / 255
        let green = CGFloat(((code & 0xFF00) >> 8)) / 255
        let blue = CGFloat((code & 0xFF)) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
