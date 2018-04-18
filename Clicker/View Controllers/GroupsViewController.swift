//
//  GroupViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 3/28/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//
import UIKit

class GroupsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SliderBarDelegate {
    
    var groupOptionsView: OptionsView!
    var groupCollectionView: UICollectionView!
    var titleLabel: UILabel!
    var newGroupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clickerBackground
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: - COLLECTIONVIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupsCellID", for: indexPath) as! GroupsCell
        if (indexPath.item == 0) {
            cell.groupType = .created
        } else {
            cell.groupType = .joined
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: groupCollectionView.frame.width, height: groupCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        groupOptionsView.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
    }
    
    // MARK: - SCROLLVIEW
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        groupOptionsView.sliderBarLeftConstraint.constant = scrollView.contentOffset.x / 2
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        groupOptionsView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
    
    // MARK: - SLIDERBAR DELEGATE
    func scrollToIndex(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        groupCollectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        titleLabel = UILabel()
        titleLabel.text = "Groups"
        titleLabel.font = ._30SemiboldFont
        titleLabel.textColor = .clickerDeepBlack
        view.addSubview(titleLabel)
        
        groupOptionsView = OptionsView(frame: .zero, options: ["Created", "Joined"], sliderBarDelegate: self)
        groupOptionsView.setBackgroundColor(color: .clickerNavBarGrey)
        view.addSubview(groupOptionsView)
        
        let layout = UICollectionViewFlowLayout()
        groupCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        groupCollectionView.alwaysBounceHorizontal = true
        groupCollectionView.delegate = self
        groupCollectionView.dataSource = self
        groupCollectionView.register(GroupsCell.self, forCellWithReuseIdentifier: "groupsCellID")
        groupCollectionView.showsVerticalScrollIndicator = false
        groupCollectionView.showsHorizontalScrollIndicator = false
        groupCollectionView.backgroundColor = .clickerBackground
        groupCollectionView.isPagingEnabled = true
        view.addSubview(groupCollectionView)
        
        newGroupButton = UIButton()
        newGroupButton.setImage(#imageLiteral(resourceName: "create_group"), for: .normal)
        newGroupButton.addTarget(self, action: #selector(newGroupAction), for: .touchUpInside)
        view.addSubview(newGroupButton)
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
        
        groupOptionsView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        groupCollectionView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(groupOptionsView.snp.bottom)
        }
        
        newGroupButton.snp.makeConstraints { make in
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
    @objc func newGroupAction() {
        let blackViewController = BlackViewController()
        blackViewController.tabController = self.tabBarController
        navigationController?.pushViewController(blackViewController, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        print(navigationController!)
    }
    
}
