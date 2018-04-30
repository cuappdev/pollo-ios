//
//  Utils.swift
//  Clicker
//
//  Created by Kevin Chan on 4/28/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation

// CONVERT INT TO MC OPTIONS
func intToMCOption(_ intOption: Int) -> String {
    return String(Character(UnicodeScalar(intOption + Int(("A" as UnicodeScalar).value))!))
}

// GET MM/DD/YYYY OF TODAY
func getTodaysDate() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd/yyyy"
    return formatter.string(from: Date())
}

// USER DEFAULTS
func encodeObjForKey(obj: Any, key: String) {
    let encodedData = NSKeyedArchiver.archivedData(withRootObject: obj)
    UserDefaults.standard.set(encodedData, forKey: key)
}

func decodeObjForKey(key: String) -> Any {
    let decodedData = UserDefaults.standard.value(forKey: key) as! Data
    return NSKeyedUnarchiver.unarchiveObject(with: decodedData)!
}
