//
//  DraftsViewController.swift
//  Clicker
//
//  Created by eoin on 4/28/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit
import IGListKit

protocol DraftsViewControllerDelegate {
    func draftsViewControllerLoadDraft(_ draft: Draft)
}

class DraftsViewController: UIViewController {
    
    // MARK: - View vars
    var visualEffectView: UIVisualEffectView!
    var backButton: UIButton!
    var titleLabel: UILabel!
    var draftsCollectionView: UICollectionView!
    var adapter: ListAdapter!
    
    // MARK: - Data vars
    var delegate: DraftsViewControllerDelegate!
    var drafts: [Draft]!
    
    // MARK: - Constants
    let titleLabelTopPadding: CGFloat = 16
    let backButtonLeftPadding: CGFloat = 18
    let backButtonLength: CGFloat = 13
    let draftsCollectionViewTopPadding: CGFloat = 32
    let draftsCollectionViewWidthInset: CGFloat = 36
    let editDraftModalSize: CGFloat = 50
    let titleLabelText = "Drafts"
    let errorText = "Error"
    let failedToDeleteDraftText = "Failed to delete draft. Try again!"
    
    init(delegate: DraftsViewControllerDelegate, drafts: [Draft]) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.drafts = drafts
    }
    
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
