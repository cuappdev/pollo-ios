//
//  DraftCell.swift
//  Pollo
//
//  Created by eoin on 4/28/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol DraftCellDelegate: class {
    func draftCellDidTapEditButton(draft: Draft)
    func draftCellDidTapLoadButton(draft: Draft)
}

class DraftCell: UICollectionViewCell {

    // MARK: - View vars
    var borderView: UIView!
    var draftTypeLabel: UILabel!
    var editButton: UIButton!
    var editImageView: UIImageView!
    var loadButton: UIButton!
    var questionLabel: UILabel!
    
    // MARK: - Data vars
    var draft: Draft!
    weak var delegate: DraftCellDelegate?
    
    // MARK: - Constants
    let draftTypeLabelTopPadding: CGFloat = 10.5
    let editButtonWidth: CGFloat = 25
    let editImageName = "dots"
    let editImageViewHeight: CGFloat = 3
    let editImageViewTopPadding: CGFloat = 30.5
    let freeResponse = "Free Response"
    let horizontalPadding: CGFloat = 18
    let multipleChoice = "Multiple Choice"
    let questionLabelMaxNumLines = 3
    let questionLabelVerticalPadding: CGFloat = 20
    let zoomDuration: TimeInterval = 0.25
    let zoomInScale: CGFloat = 0.98
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    func configure(with draft: Draft) {
        self.draft = draft
        questionLabel.text = draft.text
        let isMultipleChoice = !draft.options.isEmpty
        draftTypeLabel.text = isMultipleChoice ? multipleChoice : freeResponse
    }
    
    func setupViews() {
        backgroundColor = .clear
        
        borderView = UIView()
        borderView.layer.cornerRadius = 5
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.clickerGrey5.cgColor
        borderView.clipsToBounds = true
        contentView.addSubview(borderView)
        
        loadButton = UIButton()
        loadButton.addTarget(self, action: #selector(loadButtonPressed), for: .touchUpInside)
        loadButton.addTarget(self, action: #selector(zoomIn), for: .touchDown)
        loadButton.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
        loadButton.addTarget(self, action: #selector(zoomOut), for: .touchUpOutside)
        loadButton.layer.cornerRadius = layer.cornerRadius
        loadButton.clipsToBounds = true
        contentView.addSubview(loadButton)
        
        questionLabel = UILabel()
        questionLabel.font = ._18HeavyFont
        questionLabel.textAlignment = .left
        questionLabel.backgroundColor = .clear
        questionLabel.textColor = .clickerGrey2
        questionLabel.numberOfLines = questionLabelMaxNumLines
        questionLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(questionLabel)
        
        editButton = UIButton()
        editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        contentView.addSubview(editButton)
        
        editImageView = UIImageView()
        editImageView.image = UIImage(named: editImageName)
        editImageView.tintColor = .white
        editImageView.contentMode = .scaleAspectFit
        contentView.addSubview(editImageView)

        draftTypeLabel = UILabel()
        draftTypeLabel.textColor = .clickerGrey2
        draftTypeLabel.font = ._12SemiboldFont
        contentView.addSubview(draftTypeLabel)
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
            make.width.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        loadButton.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        questionLabel.snp.makeConstraints { make in
            make.width.equalTo(borderView.snp.width).inset(horizontalPadding + editButtonWidth)
            make.leading.equalTo(borderView.snp.leading).offset(horizontalPadding)
            make.top.equalTo(borderView.snp.top).offset(questionLabelVerticalPadding)
        }
        
        editButton.snp.makeConstraints { make in
            make.width.height.equalTo(editButtonWidth)
            make.centerY.equalTo(editImageView.snp.centerY)
            make.trailing.equalTo(borderView.snp.trailing).inset(horizontalPadding)
        }
        
        editImageView.snp.makeConstraints { make in
            make.width.equalTo(editButton.snp.width)
            make.top.equalTo(borderView).offset(editImageViewTopPadding)
            make.height.equalTo(editImageViewHeight)
            make.trailing.equalTo(borderView).inset(horizontalPadding)
        }

        draftTypeLabel.snp.makeConstraints { make in
            make.leading.equalTo(questionLabel)
            make.top.equalTo(questionLabel.snp.bottom).offset(draftTypeLabelTopPadding)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }   

}
