
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
    // CONVERT INT TO MC OPTIONS
    func intToMCOption(_ intOption: Int) -> String {
        return String(Character(UnicodeScalar(intOption + Int(("A" as UnicodeScalar).value))!))
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
    
    func createAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        return alert
    }
    
    // KEYBOARD
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    open override func becomeFirstResponder() -> Bool {
        return true
    }
    
    // SHAKE TO SEND FEEDBACK
    open override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let alert = createAlert(title: "Submit Feedback", message: "You can help us make our app even better! Tap below to submit feedback.")
            alert.addAction(UIAlertAction(title: "Submit Feedback", style: .default, handler: { action in
                let feedbackVC = FeedbackViewController()
                self.navigationController?.pushViewController(feedbackVC, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
