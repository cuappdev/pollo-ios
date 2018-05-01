//
//  BlackViewController.swift
//  Clicker
//
//  Created by eoin on 4/15/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import Presentr

protocol EndPollDelegate {
    func endedPoll()
}

class BlackAskController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, StartPollDelegate, EndPollDelegate, SocketDelegate {
    
    // name vars
    var nameView: NameView!
    
    // empty student vars
    var monkeyView: UIImageView!
    var nothingToSeeLabel: UILabel!
    var waitingLabel: UILabel!
    var downArrowImageView: UIImageView!
    var createPollButton: UIButton!
    
    // admin group vars
    var mainCollectionView: UICollectionView!
    
    // nav bar
    var navigationTitleView: NavigationTitleView!
    
    var socket: Socket!
    var sessionId: Int!
    var code: String!
    var name: String!
    var datePollsArr: [(String, [Poll])] = []
    var livePoll: Poll!
    
    let emptyAnswerCellIdentifier = "emptyAnswerCellID"
    let cardRowCellIdentifier = "cardRowCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clickerDeepBlack
        setupNavBar()
        if (datePollsArr.count == 0) {
            setupEmptyStudentPoll()
        }
        if name != code {
            setupName()
        }
    }
   
    // MARK - NAME THE POLL
    
    func setupName() {
        nameView = NameView()
        nameView.sessionId = sessionId
        nameView.code = code
        nameView.name = name
        nameView.delegate = self

        view.addSubview(nameView)

        setupNameConstraints()
    }
    
    func updateNavBar() {
        navigationTitleView.updateViews(name: name, code: code)
    }
    
    func setupNameConstraints() {
        nameView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
    }

    @objc func createPollBtnPressed() {
        let pollBuilderVC = PollBuilderViewController()
        pollBuilderVC.startPollDelegate = self
        /*let presenter = Presentr(presentationType: .fullScreen)
        presenter.backgroundOpacity = 0.6
        presenter.roundCorners = true
        presenter.cornerRadius = 15
        presenter.dismissOnSwipe = true
        presenter.dismissOnSwipeDirection = .bottom
        customPresentViewController(presenter, viewController: pollBuilderVC, animated: true, completion: nil)*/
        navigationController?.pushViewController(pollBuilderVC, animated: true)
    }
    
    func setupEmptyStudentPoll() {
        setupEmptyStudentPollViews()
        setupEmptyStudentPollConstraints()
    }
    
    func removeEmptyStudentPoll() {
        monkeyView.removeFromSuperview()
        nothingToSeeLabel.removeFromSuperview()
        waitingLabel.removeFromSuperview()
        downArrowImageView.removeFromSuperview()
    }
    
    func setupEmptyStudentPollViews() {
        monkeyView = UIImageView(image: #imageLiteral(resourceName: "monkey_emoji"))
        monkeyView.contentMode = .scaleAspectFit
        view.addSubview(monkeyView)
        
        nothingToSeeLabel = UILabel()
        nothingToSeeLabel.text = "Nothing to see here."
        nothingToSeeLabel.font = ._16SemiboldFont
        nothingToSeeLabel.textColor = .clickerBorder
        nothingToSeeLabel.textAlignment = .center
        view.addSubview(nothingToSeeLabel)
        
        waitingLabel = UILabel()
        waitingLabel.text = "You haven't asked any polls yet!\nTry it out below."
        waitingLabel.font = ._14MediumFont
        waitingLabel.textColor = .clickerMediumGray
        waitingLabel.textAlignment = .center
        waitingLabel.lineBreakMode = .byWordWrapping
        waitingLabel.numberOfLines = 0
        view.addSubview(waitingLabel)
        
        createPollButton = UIButton()
        createPollButton.setTitle("Create a poll", for: .normal)
        createPollButton.backgroundColor = .clear
        createPollButton.layer.cornerRadius = 24
        createPollButton.layer.borderWidth = 1
        createPollButton.layer.borderColor = UIColor.white.cgColor
        createPollButton.addTarget(self, action: #selector(createPollBtnPressed), for: .touchUpInside)
        view.addSubview(createPollButton)
        
        
        downArrowImageView = UIImageView(image: #imageLiteral(resourceName: "down arrow"))
        downArrowImageView.contentMode = .scaleAspectFit
        view.addSubview(downArrowImageView)
    }
    
    func setupEmptyStudentPollConstraints() {
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
        
        createPollButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.45)
            make.height.equalToSuperview().multipliedBy(0.08)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-22)
        }
        
        downArrowImageView.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(createPollButton.snp.top).offset(-20)
        }
    }
    
    func setupAdminGroup() {
        setupAdminGroupViews()
        setupAdminGroupConstraints()
    }
    
    func setupAdminGroupViews() {
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

    func setupAdminGroupConstraints() {
        mainCollectionView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.bottom.equalTo(createPollButton.snp.top).offset(-12)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
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
        cell.pollRole = .ask
        cell.endPollDelegate = self
        cell.collectionView.reloadData()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: mainCollectionView.frame.width, height: 505)
    }
    
    func updateDatePollsArr() {
        GetSortedPolls(id: "\(sessionId)").make()
            .done { datePollsArr in
                self.datePollsArr = datePollsArr
                DispatchQueue.main.async { self.mainCollectionView.reloadData() }
            }.catch { error in
                print(error)
        }
    }
    
    // MARK - SOCKET DELEGATE
    
    func sessionConnected() { }
    
    func sessionDisconnected() { }
    
    func pollStarted(_ poll: Poll) { }
    
    func pollEnded(_ poll: Poll) { }
    
    func receivedResults(_ currentState: CurrentState) {
        self.datePollsArr[datePollsArr.count - 1].1.last?.results = currentState.results
        DispatchQueue.main.async { self.mainCollectionView.reloadData() }
    }
    
    func saveSession(_ session: Session) { }
    
    func updatedTally(_ currentState: CurrentState) {
        self.datePollsArr[datePollsArr.count - 1].1.last?.results = currentState.results
        DispatchQueue.main.async { self.mainCollectionView.reloadData() }
    }
    
    // MARK: - START POLL DELEGATE
    func startPoll(text: String, type: String, options: [String]) {
        // EMIT START QUESTION
        let socketQuestion: [String:Any] = [
            "text": text,
            "type": type,
            "options": options
        ]
        socket.addDelegate(self)
        socket.socket.emit("server/poll/start", with: [socketQuestion])
        let newPoll = Poll(text: text, options: options, isLive: true)
        if (datePollsArr.count == 0) {
            self.datePollsArr.append((getTodaysDate(), [newPoll]))
            removeEmptyStudentPoll()
            setupAdminGroup()
        } else {
            self.datePollsArr[datePollsArr.count - 1].1.append(newPoll)
        }
        // HIDE CREATE POLL BUTTON
        createPollButton.alpha = 0
        createPollButton.isUserInteractionEnabled = false
        DispatchQueue.main.async { self.mainCollectionView.reloadData() }
    }
    
    // MARK: ENDED POLL DELEGATE
    func endedPoll() {
        // SHOW CREATE POLL BUTTON
        createPollButton.alpha = 1
        createPollButton.isUserInteractionEnabled = true
    }
    
    func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        // REMOVE BOTTOM SHADOW
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationTitleView = NavigationTitleView()
        navigationTitleView.updateViews(name: name, code: code)
        navigationTitleView.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        self.navigationItem.titleView = navigationTitleView
        
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
        // HIDE NAV BAR, SHOW TABBAR
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
