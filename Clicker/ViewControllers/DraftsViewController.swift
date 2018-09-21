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
    
    // MARK: - View vars
    var visualEffectView: UIVisualEffectView!
    var backButton: UIButton!
    var titleLabel: UILabel!
    var draftsCollectionView: UICollectionView!
    var drafts: [Draft]!
    
    // MARK: - Data vars
    var delegate: FillsDraftDelegate!
    
    // MARK: - Constants
    let titleLabelTopPadding: CGFloat = 16
    let backButtonLeftPadding: CGFloat = 18
    let backButtonLength: CGFloat = 13
    let draftsCollectionViewTopPadding: CGFloat = 32
    let draftsCollectionViewWidthInset: CGFloat = 36
    let titleLabelText = "Drafts"
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        backButton.contentMode = .scaleAspectFit
        view.addSubview(backButton)
        
        titleLabel = UILabel()
        titleLabel.text = titleLabelText
        titleLabel.textColor = .white
        titleLabel.font = UIFont._18SemiboldFont
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
        draftsCollectionView.register(DraftCell.self, forCellWithReuseIdentifier: Identifiers.draftCellIdentifier)
        view.addSubview(draftsCollectionView)
        
    }
    
    func setupConstraints() {
        visualEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(titleLabelTopPadding)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(backButtonLeftPadding)
            make.width.height.equalTo(backButtonLength)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        draftsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(draftsCollectionViewTopPadding)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().inset(draftsCollectionViewWidthInset)
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
