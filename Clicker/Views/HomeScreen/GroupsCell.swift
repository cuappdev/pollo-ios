//
//  GroupPreviewCell.swift
//  Clicker
//
//  Created by eoin on 4/16/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class GroupsCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var groupsTableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: - TABLEVIEW
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupPreviewCellID", for: indexPath) as! GroupPreviewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82.2
    }
    
    
    // MARK: - LAYOUT
    func setupViews() {
        groupsTableView = UITableView()
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        groupsTableView.register(GroupPreviewCell.self, forCellReuseIdentifier: "groupPreviewCellID")
        groupsTableView.separatorStyle = .none
        addSubview(groupsTableView)
    }
    
    func setupConstraints() {
        groupsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

