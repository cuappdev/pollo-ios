//
//  UIViewController+Shared.swift
//  Clicker
//
//  Created by Kevin Chan on 2/13/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import Neutron
import Alamofire
import SwiftyJSON

extension UIViewController {
    // Convert integers to Multiple Choice Options, i.e. A, B, ...
    func intToMCOption(_ intOption: Int) -> String {
        return String(Character(UnicodeScalar(intOption + Int(("A" as UnicodeScalar).value))!))
    }
    
    // User Defaults
    func encodeObjForKey(obj: Any, key: String) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: obj)
        UserDefaults.standard.set(encodedData, forKey: key)
    }
    
    func decodeObjForKey(key: String) -> Any {
        let decodedData = UserDefaults.standard.value(forKey: key) as! Data
        return NSKeyedUnarchiver.unarchiveObject(with: decodedData)
    }
    
    func createAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        return alert
    }
    
    // Handle keyboard
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
