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
    
    var socket: Socket!
    var code: String!
    var sessionId: Int!
    var datePollsArr: [(String, [Poll])] = []
    
    let cardRowCellIdentifier = "cardRowCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clickerDeepBlack
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        socket.addDelegate(self)
        if (datePollsArr.count == 0) {
            setupEmpty()
        } else {
            setupViews()
            setupConstraints()
        }
        setupNavBar()
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
        mainCollectionView.register(CardRowCell.self, forCellWithReuseIdentifier: cardRowCellIdentifier)
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
    
    func removeEmpty() {
        monkeyView.removeFromSuperview()
        nothingToSeeLabel.removeFromSuperview()
        waitingLabel.removeFromSuperview()
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
        return datePollsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardRowCellIdentifier, for: indexPath) as! CardRowCell
        cell.polls = datePollsArr[indexPath.item].1
        cell.socket = socket
        cell.pollRole = .answer
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: mainCollectionView.frame.width, height: 505)
    }
    
    
    // MARK - SOCKET DELAGATE
    
    func sessionConnected() { }
    
    func sessionDisconnected() { }
    
    func pollStarted(_ poll: Poll) {
        if (datePollsArr.count == 0) {
            removeEmpty()
            setupViews()
            setupConstraints()
            datePollsArr.append((getTodaysDate(), []))
        }
        DispatchQueue.main.async { self.mainCollectionView.reloadData() }
    }
    
    func pollEnded(_ poll: Poll) {
        updateDatePollsArr()
    }
    
    func receivedResults(_ currentState: CurrentState) {
        updateDatePollsArr()
    }
    
    func saveSession(_ session: Session) { }
    
    func updatedTally(_ currentState: CurrentState) { }
    
    func updateDatePollsArr() {
        GetSortedPolls(id: "\(sessionId)").make()
            .done { datePollsArr in
                self.datePollsArr = datePollsArr
                DispatchQueue.main.async { self.mainCollectionView.reloadData() }
            }.catch { error in
                print(error)
            }
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
        socket.socket.disconnect()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // HIDE NAV BAR
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

