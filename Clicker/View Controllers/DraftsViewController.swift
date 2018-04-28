//
//  DraftsViewController.swift
//  Clicker
//
//  Created by eoin on 4/28/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class DraftsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var titleLabel: UILabel!
    var draftsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("vc pushed")
        view.backgroundColor = .clickerDraftsBlack
        
        setupNavBar()
        setupViews()
        setupConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func setupNavBar() {
       
        titleLabel = UILabel()
        titleLabel.text = "Drafts"
        titleLabel.textColor = .white
        titleLabel.font = UIFont._16SemiboldFont
        titleLabel.textAlignment = .center
        self.navigationItem.titleView = titleLabel
        
        let backImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(goBack))
        navigationController?.isToolbarHidden = false
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupViews() {
        draftsTableView = UITableView()
        draftsTableView.backgroundColor = .clear
        draftsTableView.delegate = self
        draftsTableView.dataSource = self
        draftsTableView.separatorStyle = .none
        draftsTableView.register(DraftCell.self, forCellReuseIdentifier: "draftCellID")
        view.addSubview(draftsTableView)
        
    }
    
    func setupConstraints() {
        draftsTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    // MARK - TABLE VIEW DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "draftCellID", for: indexPath) as! DraftCell
        return cell
    }

}
