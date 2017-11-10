//
//  PendingViewController.swift
//  Clicker
//
//  Created by Keivan Shahida on 10/29/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

class PendingViewController: UIViewController {

    var pendingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerBackground
        
        pendingLabel = UILabel()
        pendingLabel.text = "Waiting for question..."
        pendingLabel.textAlignment = .center
        view.addSubview(pendingLabel)
        
        pendingLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(view.frame.width).multipliedBy(0.7)
            make.height.equalTo(50)
        }
    }
    


}
