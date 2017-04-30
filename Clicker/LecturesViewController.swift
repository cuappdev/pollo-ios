//
//  CourseViewController.swift
//  Clicker
//
//  Created by AE7 on 3/24/17.
//  Copyright © 2017 cuappdev. All rights reserved.
//

import UIKit

class LecturesViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LectureCell") ??
            UITableViewCell(style: .default, reuseIdentifier: "LectureCell")
        
        cell.textLabel?.text = indexPath.row == 0 ? "LIVE Lecture #5" : "Lecture #\(5 - indexPath.row)"
        cell.detailTextLabel?.text = "Dan Li"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let c = QuestionsViewController()
        c.title = "LIVE Lecture #\(5 - indexPath.row)"
        navigationController?.pushViewController(c, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

