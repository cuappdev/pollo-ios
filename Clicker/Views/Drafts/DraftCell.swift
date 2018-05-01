//
//  DraftCell.swift
//  Clicker
//
//  Created by eoin on 4/28/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class DraftCell: UICollectionViewCell {

    var titleTextView: UITextView!
    var optionsImageView: UIImageView!
    
    var draft: Draft!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setupCell() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        backgroundColor = .clear
        layer.cornerRadius = 15
        layer.borderColor = UIColor.clickerBorder.cgColor
        layer.borderWidth = 1
        clipsToBounds = true
        
        titleTextView = UITextView()
        titleTextView.text = draft.text
        titleTextView.font = ._18SemiboldFont
        titleTextView.textAlignment = .left
        titleTextView.isScrollEnabled = false
        titleTextView.isSelectable = false
        titleTextView.isEditable = false
        titleTextView.isOpaque = false
        titleTextView.backgroundColor = .clear
        titleTextView.textColor = .white
        addSubview(titleTextView)
        
        optionsImageView = UIImageView(image: UIImage(named: "ellipsis"))
        addSubview(optionsImageView)
    }
    
    func setupConstraints() {
        titleTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18.5)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(41.9)
        }
        
        optionsImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(30)
            optionsImageView.sizeToFit()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }   

}
