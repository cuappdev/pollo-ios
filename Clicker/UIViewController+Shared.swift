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
    func encodeObjForKey(obj: Any, key: String) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: obj)
        UserDefaults.standard.set(encodedData, forKey: key)
    }
    
    func decodeObjForKey(key: String) -> Any {
        let decodedData = UserDefaults.standard.value(forKey: key) as! Data
        return NSKeyedUnarchiver.unarchiveObject(with: decodedData)
    }
    
    func requestJSON(route: String, method: HTTPMethod, parameters: Parameters, completion: @escaping (_ response: [String:Any]) -> Void) {
        Alamofire.request(route, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON()
            .then { json -> Void in
                completion(json as! [String:Any])
            }.catch { error -> Void in
                print(error)
            }
    }
    
    func createAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        return alert
    }
}
