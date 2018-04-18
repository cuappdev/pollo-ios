//
//  BlackAnswerViewControllerTableViewCell.swift
//  Clicker
//
//  Created by eoin on 4/17/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class BlackAnswerController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SocketDelegate {
    
    var tabController: UITabBarController!
    var socket: Socket!
    
    var mainCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clickerDeepBlack
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        setupViews()
        setupConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        let layout = UICollectionViewFlowLayout()
        mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.register(DateCell.self, forCellWithReuseIdentifier: "dateCellID")
        mainCollectionView.register(EmptyAnswerCell.self, forCellWithReuseIdentifier: "emptyAnswerCellID")
        mainCollectionView.showsVerticalScrollIndicator = false
        mainCollectionView.showsHorizontalScrollIndicator = false
        mainCollectionView.backgroundColor = .clear
        mainCollectionView.isPagingEnabled = true
        view.addSubview(mainCollectionView)
    }
    
    func setupConstraints() {
        mainCollectionView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
                make.bottom.equalTo(topLayoutGuide.snp.bottom)
            }
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - COLLECTIONVIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        switch indexPath.row {
        case 1:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCellID", for: indexPath) as! DateCell

        default:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyAnswerCellID", for: indexPath) as! EmptyAnswerCell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: mainCollectionView.frame.width, height: 505)
    }
    
    
    // MARK - SOCKET DELAGATE
    
    func sessionConnected() {
        
    }
    
    func sessionDisconnected() {
        
    }
    
    func questionStarted(_ question: Question) {
        
    }
    
    func questionEnded(_ question: Question) {
        
    }
    
    func receivedResults(_ currentState: CurrentState) {
        
    }
    
    func savePoll(_ poll: Poll) {
        
    }
    
    func updatedTally(_ currentState: CurrentState) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // HIDE NAV BAR, SHOW TABBAR
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        tabController?.tabBar.isHidden = false
    }
}

