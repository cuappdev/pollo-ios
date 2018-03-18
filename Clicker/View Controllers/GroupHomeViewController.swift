//
//  GroupHomeViewController.swift
//  Clicker
//
//  Created by eoin on 3/18/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class GroupHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var groupCollectionView: UICollectionView!
    var whiteView: UIView!
    var bottomView: UIView!
    var createQuestionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clickerBackground

        setupViews()
        setupConstraints()
        setupNavBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - SETUP
    
    func setupViews() {
        whiteView = UIView()
        whiteView.backgroundColor = .white
        view.addSubview(whiteView)
        
        bottomView = UIView()
        bottomView.backgroundColor = .white
        view.addSubview(bottomView)
        
        createQuestionButton = UIButton()
        createQuestionButton.setTitle("Create New Session", for: .normal)
        createQuestionButton.setTitleColor(.white, for: .normal)
        createQuestionButton.titleLabel?.font = UIFont._18MediumFont
        createQuestionButton.backgroundColor = .clickerGreen
        createQuestionButton.layer.cornerRadius = 8
        createQuestionButton.addTarget(self, action: #selector(createNewQuestion), for: .touchUpInside)
        whiteView.addSubview(createQuestionButton)
        
        
        let layout = UICollectionViewFlowLayout()
        groupCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        
        groupCollectionView.alwaysBounceVertical = true
        groupCollectionView.delegate = self
        groupCollectionView.dataSource = self
        groupCollectionView.showsVerticalScrollIndicator = false
        groupCollectionView.showsHorizontalScrollIndicator = false
        groupCollectionView.register(DateCell.self, forCellWithReuseIdentifier: "dateCellID")
        groupCollectionView.register(PastQuestionCell.self, forCellWithReuseIdentifier: "pastQuestionCellID")
        groupCollectionView.register(NewGroupCell.self, forCellWithReuseIdentifier: "newGroupCellID")
        groupCollectionView.backgroundColor = .clickerBackground
        view.addSubview(groupCollectionView)
    }
    
    func setupConstraints() {
        whiteView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(91)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
        
        bottomView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(whiteView.snp.bottom)
        }
        
        createQuestionButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.frame.width * 0.90, height: 55))
            make.center.equalToSuperview()
        }
        
        groupCollectionView.snp.makeConstraints{ make in
            make.width.equalToSuperview()
            make.left.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(bottomLayoutGuide.snp.top)
            }
            make.bottom.equalTo(whiteView.snp.top)
        }
        
    }
    
    func setupNavBar() {
        UINavigationBar.appearance().barTintColor = .clickerNavBarGrey
        //UINavigationBar.appearance().backgroundColor = .clickerNavBarGrey
        //UINavigationBar.appearance().tintColor = .clickerNavBarGrey

        self.title = "title"
    }
    
    
    // MARK - NEW QUESTION
    @objc func createNewQuestion() {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCellID", for: indexPath) as! DateCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newGroupCellID", for: indexPath) as! NewGroupCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: view.frame.width, height: 72)
        } else {
            return CGSize(width: view.frame.width, height: 120)
        }
    }
    
}
