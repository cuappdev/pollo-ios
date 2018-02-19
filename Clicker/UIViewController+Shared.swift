//
//  UIViewController+Shared.swift
//  Clicker
//
//  Created by Kevin Chan on 2/13/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

extension UIViewController {
    func encodeObjForKey(obj: Any, key: String) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: obj)
        UserDefaults.standard.set(encodedData, forKey: key)
    }
    
    func decodeObjForKey(key: String) -> Any {
        let decodedData = UserDefaults.standard.value(forKey: key) as! Data
        return NSKeyedUnarchiver.unarchiveObject(with: decodedData)
    }
}
