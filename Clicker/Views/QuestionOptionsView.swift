//
//  QuestionOptionsView.swift
//  Clicker
//
//  Created by Kevin Chan on 2/5/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import SnapKit
import UIKit

class QuestionOptionsView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(red: 247/255, green: 249/255, blue: 250/255, alpha: 1.0)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    var options: [String]!
    let sliderBar = UIView()
    var sliderBarLeftConstraint: NSLayoutConstraint!
    var controller: CreateQuestionViewController!
    
    init(frame: CGRect, options: [String], controller: CreateQuestionViewController) {
        super.init(frame: frame)
        self.options = options
        self.controller = controller
        collectionView.register(QuestionOptionCell.self, forCellWithReuseIdentifier: "questionOptionCellId")
        addSubview(collectionView)
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
        setupSliderBar()
        layoutSubviews()
    }
    
    func setupSliderBar() {
        sliderBar.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1.0)
        addSubview(sliderBar)
        sliderBarLeftConstraint = sliderBar.leftAnchor.constraint(equalTo: leftAnchor)
        sliderBarLeftConstraint.isActive = true
    }
    
    override func layoutSubviews() {
        collectionView.snp.updateConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
        sliderBar.snp.updateConstraints { make in
            make.size.equalTo(CGSize(width: frame.width * 0.5, height: 1.0))
            make.bottom.equalToSuperview()
        }
    }
    
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "questionOptionCellId", for: indexPath) as! QuestionOptionCell
        cell.optionLabel.text = options[indexPath.item]
        
        return cell
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: frame.width / CGFloat(options.count), height: frame.height)
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        controller.scrollToIndex(index: indexPath.item)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class QuestionOptionCell: UICollectionViewCell {
    
    let optionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont._16MediumFont
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(optionLabel)
        optionLabel.snp.updateConstraints { make in
            make.size.equalTo(CGSize(width: frame.width, height: frame.height * 0.4318181818))
            make.center.equalToSuperview()
        }
    }
    

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




