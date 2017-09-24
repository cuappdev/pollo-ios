//
//  HomeViewController.swift
//  Clicker
//
//  Created by Keivan Shahida on 9/24/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .blue // TEMP
    }


    // MARK: - TableView DataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
