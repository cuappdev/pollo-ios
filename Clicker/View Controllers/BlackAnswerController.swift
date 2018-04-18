//
//  BlackAnswerViewControllerTableViewCell.swift
//  Clicker
//
//  Created by eoin on 4/17/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class BlackAnswerController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SocketDelegate {
    
    var mainCollectionView: UICollectionView!
    var monkeyView: UIImageView!
    var nothingToSeeLabel: UILabel!
    var waitingLabel: UILabel!
    
    var tabController: UITabBarController!
    var socket: Socket!
    var code: String!
    var datePollsDict: [String:[Poll]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clickerDeepBlack
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        if (datePollsDict.count == 0) {
            setupEmpty()
        } else {
            setupViews()
            setupConstraints()
        }
        setupNavBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - LAYOUT
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
    
    func setupEmpty() {
        setupEmptyViews()
        setupEmptyConstraints()
    }
    
    func setupEmptyViews() {
        monkeyView = UIImageView(image: #imageLiteral(resourceName: "monkey_emoji"))
        monkeyView.contentMode = .scaleAspectFit
        view.addSubview(monkeyView)
        
        nothingToSeeLabel = UILabel()
        nothingToSeeLabel.text = "Nothing to see yet."
        nothingToSeeLabel.font = ._16SemiboldFont
        nothingToSeeLabel.textColor = .clickerBorder
        nothingToSeeLabel.textAlignment = .center
        view.addSubview(nothingToSeeLabel)
        
        waitingLabel = UILabel()
        waitingLabel.text = "Waiting for the host to post a poll."
        waitingLabel.font = ._14MediumFont
        waitingLabel.textColor = .clickerMediumGray
        waitingLabel.textAlignment = .center
        waitingLabel.lineBreakMode = .byWordWrapping
        waitingLabel.numberOfLines = 0
        view.addSubview(waitingLabel)
    }
    
    func setupEmptyConstraints() {
        monkeyView.snp.makeConstraints { make in
            make.width.equalTo(31)
            make.height.equalTo(34)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(142)
        }
        
        nothingToSeeLabel.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(19)
            make.centerX.equalToSuperview()
            make.top.equalTo(monkeyView.snp.bottom).offset(21)
        }
        
        waitingLabel.snp.makeConstraints { make in
            make.width.equalTo(220)
            make.height.equalTo(36)
            make.centerX.equalToSuperview()
            make.top.equalTo(nothingToSeeLabel.snp.bottom).offset(11)
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
    
    func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        // REMOVE BOTTOM SHADOW
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let codeLabel = UILabel()
        if let c = code {
            codeLabel.text = "Code: \(c)"
        }
        codeLabel.textColor = .white
        codeLabel.font = UIFont._16SemiboldFont
        codeLabel.textAlignment = .center
        self.navigationItem.titleView = codeLabel
        
        let backImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
        let settingsImage = UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(goBack))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: nil)
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

