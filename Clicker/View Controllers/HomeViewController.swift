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
        
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(LiveSessionHeader.self, forHeaderFooterViewReuseIdentifier: "liveSessionHeader")
        tableView.register(PastSessionHeader.self, forHeaderFooterViewReuseIdentifier: "pastSessionHeader")
        tableView.register(LiveSessionTableViewCell.self, forCellReuseIdentifier: "liveSessionCell")
        tableView.register(PastSessionTableViewCell.self, forCellReuseIdentifier: "pastSessionCell")
    }
    
    // MARK: - CELLS
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch(indexPath.section) {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "liveSessionCell") as! LiveSessionTableViewCell
            return cell
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "pastSessionCell") as! PastSessionTableViewCell
            return cell
        default:
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.section) {
        case 0:
            print("liveSession")
            let viewController = LiveSessionViewController() //TEMP
            let navigationController = self.navigationController!
            navigationController.pushViewController(viewController, animated: true)
            
        case 1:
            print("pastSession")
        default:
            print("default")
        }
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
            return Constants.Headers.Height.liveSession
        case 1:
            return Constants.Headers.Height.pastSession
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
        case 0:
            return 1 //TEMP
        case 1:
            return 3 //TEMP
        default:
            return 0
        }
    }
}
