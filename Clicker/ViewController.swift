//
//  ViewController.swift
//  Clicker
//
//  Created by Daniel Li on 2/12/17.
//  Copyright © 2017 cuappdev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GIDSignInUIDelegate, UITableViewDataSource, UITableViewDelegate {

    var signInBtn: GIDSignInButton!
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home Screen"
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        signInBtn = GIDSignInButton(frame: CGRect(x:15, y:15, width:100, height:50))
        
        tableView = UITableView(frame: CGRect(x:0, y: 0, width: view.bounds.width, height: view.bounds.height), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        view.addSubview(signInBtn)

        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell") ??
                    UITableViewCell(style: .default, reuseIdentifier: "CourseCell")
        
        cell.textLabel?.text = "Course 1"
        cell.detailTextLabel?.text = "Dan Li"
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let c = CourseViewController()
        c.title = "Course 1"
        navigationController?.pushViewController(c, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

