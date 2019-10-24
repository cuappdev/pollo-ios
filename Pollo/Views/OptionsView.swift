//
//  QuestionOptionsView.swift
//  Pollo
//
//  Created by Kevin Chan on 2/5/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import SnapKit
import UIKit

protocol SliderBarDelegate: class {
    func scrollToIndex(index: Int)
}

class OptionsView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    var options: [String]!
    var sliderBar: UIView!
    var sliderBarLeftConstraint: NSLayoutConstraint!
    weak var sliderBarDelegate: SliderBarDelegate?
    
    // MARK: - INITIALIZATION
    init(frame: CGRect, options: [String], sliderBarDelegate: SliderBarDelegate) {
        super.init(frame: frame)
        self.options = options
        self.sliderBarDelegate = sliderBarDelegate
        backgroundColor = .clear
        
        setupViews()
        layoutSubviews()
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(QuestionOptionCell.self, forCellWithReuseIdentifier: Identifiers.questionOptionCellIdentifier)
        addSubview(collectionView)
        
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
        
        sliderBar = UIView()
        sliderBar.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1.0)
        addSubview(sliderBar)
        bringSubviewToFront(sliderBar)
        sliderBarLeftConstraint = sliderBar.leftAnchor.constraint(equalTo: leftAnchor)
        sliderBarLeftConstraint.isActive = true
    }
    
    override func layoutSubviews() {
        collectionView.snp.updateConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
        sliderBar.snp.updateConstraints { make in
            make.size.equalTo(CGSize(width: frame.width * 0.5, height: 2.0))
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - COLLECTIONVIEW
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.questionOptionCellIdentifier, for: indexPath) as! QuestionOptionCell
        cell.optionLabel.text = options[indexPath.item]
        cell.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: frame.width / CGFloat(options.count), height: frame.height)
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sliderBarDelegate?.scrollToIndex(index: indexPath.item)
        let selectedCell = collectionView.cellForItem(at: indexPath) as! QuestionOptionCell
        selectedCell.optionLabel.textColor = .black
        let unselectedIndexPath: IndexPath
        unselectedIndexPath = indexPath.row == 0 ? IndexPath(item: 1, section: 0) : IndexPath(item: 0, section: 0)
        let unselectedCell = collectionView.cellForItem(at: unselectedIndexPath) as! QuestionOptionCell
        unselectedCell.optionLabel.textColor = .blueGrey
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class QuestionOptionCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            optionLabel.textColor = isSelected ? .black : .blueGrey
        }
    }
    
    let optionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .blueGrey
        label.font = ._16SemiboldFont
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
