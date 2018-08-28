//
//  DraftsViewController.swift
//  Clicker
//
//  Created by eoin on 4/28/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol FillsDraftDelegate {
    func fillDraft(_ draft: Draft)
}

class DraftsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var visualEffectView: UIVisualEffectView!
    var backButton: UIButton!
    var titleLabel: UILabel!
    var draftsCollectionView: UICollectionView!
    var drafts: [Draft]!
    
    var delegate: FillsDraftDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("vc pushed")
        view.backgroundColor = .clear
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.addSubview(visualEffectView)
        
        backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "whiteExit"), for: .normal)
        backButton.addTarget(self, action: #selector(backBtnPressed), for: .touchUpInside)
        view.addSubview(backButton)
        
        titleLabel = UILabel()
        titleLabel.text = "Drafts"
        titleLabel.textColor = .white
        titleLabel.font = UIFont._16SemiboldFont
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 6
        layout.scrollDirection = .vertical
        draftsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        draftsCollectionView.backgroundColor = .clear
        draftsCollectionView.delegate = self
        draftsCollectionView.dataSource = self
        draftsCollectionView.isScrollEnabled = true
        draftsCollectionView.allowsSelection = true
        draftsCollectionView.showsVerticalScrollIndicator = false
        draftsCollectionView.showsHorizontalScrollIndicator = false
        draftsCollectionView.register(DraftCell.self, forCellWithReuseIdentifier: "draftCellID")
        view.addSubview(draftsCollectionView)
        
    }
    
    func setupConstraints() {
        visualEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(32)
            make.width.height.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButton)
        }
        
        draftsCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().inset(36)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: ACTIONS
    @objc func backBtnPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
