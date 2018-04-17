//
//  PollsCell.swift
//  Clicker
//
//  Created by eoin on 4/16/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class PollsCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var pollsTableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: - TABLEVIEW
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pollPreviewCellID", for: indexPath) as! PollPreviewCell
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
        pollsTableView = UITableView()
        pollsTableView.delegate = self
        pollsTableView.dataSource = self
        pollsTableView.register(PollPreviewCell.self, forCellReuseIdentifier: "pollPreviewCellID")
        pollsTableView.separatorStyle = .none
        addSubview(pollsTableView)
    }
    
    func setupConstraints() {
        pollsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
