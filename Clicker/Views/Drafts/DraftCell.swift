//
//  DraftCell.swift
//  Clicker
//
//  Created by eoin on 4/28/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol DraftCellDelegate {
    func draftCellDidTapLoadButton(draft: Draft)
    func draftCellDidTapEditButton(draft: Draft)
}

class DraftCell: UICollectionViewCell {

    // MARK: - View vars
    var loadButton: UIButton!
    var questionLabel: UILabel!
    var borderView: UIView!
    var editButton: UIButton!
    var editImageView: UIImageView!
    
    // MARK: - Data vars
    var delegate: DraftCellDelegate?
    var draft: Draft!
    
    // MARK: - Constants
    let questionLabelHorizontalPadding: CGFloat = 18.5
    let questionLabelVerticalPadding: CGFloat = 20
    let borderViewPadding: CGFloat = 18
    let editButtonWidth: CGFloat = 25
    let zoomInScale: CGFloat = 0.98
    let zoomDuration: TimeInterval = 0.25
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    func configure(with draft: Draft) {
        self.draft = draft
        questionLabel.text = draft.text
    }
    
    func setupViews() {
        backgroundColor = .clear
        
        borderView = UIView()
        borderView.layer.cornerRadius = 15
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.white.cgColor
        borderView.clipsToBounds = true
        addSubview(borderView)
        
        loadButton = UIButton()
        loadButton.addTarget(self, action: #selector(loadButtonPressed), for: .touchUpInside)
        loadButton.addTarget(self, action: #selector(zoomIn), for: .touchDown)
        loadButton.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
        loadButton.addTarget(self, action: #selector(zoomOut), for: .touchUpOutside)
        loadButton.layer.cornerRadius = layer.cornerRadius
        loadButton.clipsToBounds = true
        addSubview(loadButton)
        
        questionLabel = UILabel()
        questionLabel.font = ._18SemiboldFont
        questionLabel.textAlignment = .left
        questionLabel.backgroundColor = .clear
        questionLabel.textColor = .white
        questionLabel.numberOfLines = 2
        questionLabel.lineBreakMode = .byTruncatingTail
        addSubview(questionLabel)
        
        editButton = UIButton()
        editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        addSubview(editButton)
        
        editImageView = UIImageView()
        editImageView.image = #imageLiteral(resourceName: "ellipsis").withRenderingMode(.alwaysTemplate)
        editImageView.tintColor = .white
        addSubview(editImageView)
    }
    
    @objc func zoomIn(sender: UIButton) {
        UIView.animate(withDuration: zoomDuration) {
            sender.transform = CGAffineTransform(scaleX: self.zoomInScale, y: self.zoomInScale)
            let transform: CGAffineTransform = CGAffineTransform(scaleX: self.zoomInScale, y: self.zoomInScale)
            self.borderView.transform = transform
            self.questionLabel.transform = transform
            self.editImageView.transform = transform
        }
    }
    
    @objc func zoomOut(sender: UIButton) {
        UIView.animate(withDuration: zoomDuration) {
            sender.transform = .identity
            self.borderView.transform = .identity
            self.questionLabel.transform = .identity
            self.editImageView.transform = .identity
        }
    }
    
    @objc func editButtonPressed() {
        delegate?.draftCellDidTapEditButton(draft: draft)
    }
    
    @objc func loadButtonPressed() {
        delegate?.draftCellDidTapLoadButton(draft: draft)
    }
    
    func setupConstraints() {
        borderView.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-borderViewPadding * 2)
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        loadButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        questionLabel.snp.makeConstraints { make in
            make.width.equalTo(borderView.snp.width).inset(questionLabelHorizontalPadding + editButtonWidth)
            make.height.equalToSuperview()
            make.left.equalTo(borderView.snp.left).offset(questionLabelHorizontalPadding)
            make.centerY.equalToSuperview()
        }
        
        editButton.snp.makeConstraints { make in
            make.width.equalTo(editButtonWidth)
            make.height.equalTo(editButtonWidth)
            make.centerY.equalToSuperview()
            make.right.equalTo(borderView.snp.right).inset(questionLabelHorizontalPadding)
        }
        
        editImageView.snp.makeConstraints { make in
            make.width.equalTo(editButton.snp.width)
            make.center.equalTo(editButton.snp.center)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }   

}
