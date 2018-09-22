//
//  DraftsViewController.swift
//  Clicker
//
//  Created by eoin on 4/28/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import IGListKit

protocol FillsDraftDelegate {
    func fillDraft(_ draft: Draft)
}

class DraftsViewController: UIViewController {
    
    // MARK: - View vars
    var visualEffectView: UIVisualEffectView!
    var backButton: UIButton!
    var titleLabel: UILabel!
    var draftsCollectionView: UICollectionView!
    var adapter: ListAdapter!
    
    // MARK: - Data vars
    var drafts: [Draft]!
    var delegate: FillsDraftDelegate!
    
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
        draftsCollectionView.isScrollEnabled = true
        draftsCollectionView.allowsSelection = true
        draftsCollectionView.showsVerticalScrollIndicator = false
        draftsCollectionView.showsHorizontalScrollIndicator = false
        draftsCollectionView.register(DraftCell.self, forCellWithReuseIdentifier: Identifiers.draftCellIdentifier)
        view.addSubview(draftsCollectionView)
        
        let updater: ListAdapterUpdater = ListAdapterUpdater()
        adapter = ListAdapter(updater: updater, viewController: self)
        adapter.collectionView = draftsCollectionView
        adapter.dataSource = self
        
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
        
        guard let nav = presentingViewController as? UINavigationController else { return }
        draftsCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height + nav.navigationBar.frame.height + 7.5)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
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
