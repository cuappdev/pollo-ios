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
    

    var titleLabel: UILabel!
    var draftsCollectionView: UICollectionView!
    var drafts: [Draft]!
    
    var delegate: FillsDraftDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("vc pushed")
        view.backgroundColor = .clicker85Black
        
        setupNavBar()
        setupViews()
        setupConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
        //self.removeFromParentViewController()
    }
    
    func setupViews() {
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
        draftsCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().inset(36)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK - COLLECTION VIEW delegate/data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drafts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = draftsCollectionView.dequeueReusableCell(withReuseIdentifier: "draftCellID", for: indexPath) as! DraftCell
        cell.draft = drafts[drafts.count - (indexPath.row + 1)]
        cell.setupCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = draftsCollectionView.frame.width
        let height: CGFloat = 100.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected item at ", indexPath.row)
        delegate.fillDraft(drafts[drafts.count - (indexPath.row + 1)])
        navigationController?.popViewController(animated: true)
    }

    
    func setupNavBar() {
        navigationController?.navigationBar.isHidden = false
        // REMOVE BOTTOM SHADOW
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let backImage = UIImage(named: "SmallExitIcon")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(goBack))
        
        titleLabel = UILabel()
        titleLabel.text = "Drafts"
        titleLabel.textColor = .white
        titleLabel.font = UIFont._16SemiboldFont
        titleLabel.textAlignment = .center
        self.navigationItem.titleView = titleLabel
        
    }
    
}
