//
//  PollsViewController.swift
//  Clicker
//
//  Created by eoin on 4/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//
import UIKit
import GoogleSignIn

class PollsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SliderBarDelegate {
    
    var pollsOptionsView: OptionsView!
    var pollsCollectionView: UICollectionView!
    var titleLabel: UILabel!
    var newPollButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerNavBarLightGrey
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: - COLLECTIONVIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pollsCellID", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: pollsCollectionView.frame.width, height: pollsCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pollsOptionsView.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
    }
    
    // MARK: - SCROLLVIEW
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pollsOptionsView.sliderBarLeftConstraint.constant = scrollView.contentOffset.x / 2
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        pollsOptionsView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
    
    // MARK: - SLIDERBAR DELEGATE
    func scrollToIndex(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        pollsCollectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        titleLabel = UILabel()
        titleLabel.text = "Polls"
        titleLabel.font = ._30SemiboldFont
        titleLabel.textColor = .clickerDeepBlack
        view.addSubview(titleLabel)
        
        pollsOptionsView = OptionsView(frame: .zero, options: ["Created", "Joined"], sliderBarDelegate: self)
        pollsOptionsView.setBackgroundColor(color: .clickerNavBarLightGrey)
        view.addSubview(pollsOptionsView)
        
        let layout = UICollectionViewFlowLayout()
        pollsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        pollsCollectionView.alwaysBounceHorizontal = true
        pollsCollectionView.delegate = self
        pollsCollectionView.dataSource = self
        pollsCollectionView.register(PollsCell.self, forCellWithReuseIdentifier: "pollsCellID")
        pollsCollectionView.showsVerticalScrollIndicator = false
        pollsCollectionView.showsHorizontalScrollIndicator = false
        pollsCollectionView.backgroundColor = .clickerBackground
        pollsCollectionView.isPagingEnabled = true
        view.addSubview(pollsCollectionView)
        
        newPollButton = UIButton()
        newPollButton.setImage(#imageLiteral(resourceName: "create_poll"), for: .normal)
        newPollButton.addTarget(self, action: #selector(newPollAction), for: .touchUpInside)
        view.addSubview(newPollButton)
        
        }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(90)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom).offset(90)
            }
            make.centerX.equalToSuperview()
            make.height.equalTo(35.5)
        }
        
        
        pollsOptionsView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        pollsCollectionView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(pollsOptionsView.snp.bottom)
        }
        
        newPollButton.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom).offset(15)
            }
            make.width.equalTo(19)
            make.height.equalTo(19)
            make.right.equalToSuperview().offset(-15)
        }
        
        
    }
    
    // MARK - actions
    @objc func newPollAction() {
        GenerateCode().make()
            .done { code in
                StartSession(code: code, name: code, isGroup: false).make()
                    .done { session in
                        let socket = Socket(id: "\(session.id)", userType: "admin")
                        let blackAskVC = BlackAskController()
                        blackAskVC.tabController = self.tabBarController
                        blackAskVC.socket = socket
                        blackAskVC.code = code
                        blackAskVC.datePollsDict = [:]
                        self.navigationController?.pushViewController(blackAskVC, animated: true)
                        self.navigationController?.setNavigationBarHidden(false, animated: true)
                        self.tabBarController?.tabBar.isHidden = true
                    }.catch { error in
                        print(error)
                }
            }.catch { error in
                print(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.parent is UINavigationController {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
}
