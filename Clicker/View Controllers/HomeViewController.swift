//
//  HomeViewController.swift
//  Clicker
//
//  Created by Keivan Shahida on 9/24/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {

    // MARK: - INITIALIZATION
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "CliquePod"
        
        tableView.separatorStyle = .none
        tableView.bounces = false
        
        tableView.register(LiveSessionHeader.self, forHeaderFooterViewReuseIdentifier: "liveSessionHeader")
        tableView.register(PastSessionHeader.self, forHeaderFooterViewReuseIdentifier: "pastSessionHeader")
        tableView.register(LiveSessionTableViewCell.self, forCellReuseIdentifier: "liveSessionCell")
        tableView.register(PastSessionTableViewCell.self, forCellReuseIdentifier: "pastSessionCell")
    }

    // MARK: - CELLS
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return PastSessionTableViewCell() // TEMP
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    // MARK: - SECTIONS
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UITableViewHeaderFooterView()
        switch (section) {
        case 0:
            headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "liveSessionHeader") as! LiveSessionHeader
            return headerView
        case 1:
            headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "pastSessionHeader") as! PastSessionHeader
            return headerView
        default:
            return headerView
        }
    }
    
    override  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch(section){
        case 0:
            return 44.5
        case 1:
            return 53.5
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }
}
