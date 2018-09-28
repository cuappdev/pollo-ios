//
//  DraftCell.swift
//  Clicker
//
//  Created by eoin on 4/28/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol DraftCellDelegate {
    func draftCellDidSelectDraft(draft: Draft)
}

class DraftCell: UICollectionViewCell {

    // MARK: - View vars
    var selectDraftButton: UIButton!
    var questionLabel: UILabel!
    var borderView: UIView!
    var editImageView: UIImageView!
    
    // MARK: - Data vars
    var delegate: DraftCellDelegate?
    var draft: Draft!
    
    // MARK: - Constants
    let questionLabelHorizontalPadding: CGFloat = 18.5
    let questionLabelVerticalPadding: CGFloat = 20
    let borderViewPadding: CGFloat = 18
    let editImageViewWidth: CGFloat = 25
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
        
        selectDraftButton = UIButton()
        selectDraftButton.addTarget(self, action: #selector(selectDraftButtonPressed), for: .touchUpInside)
        selectDraftButton.addTarget(self, action: #selector(zoomIn), for: .touchDown)
        selectDraftButton.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
        selectDraftButton.addTarget(self, action: #selector(zoomOut), for: .touchUpOutside)
        selectDraftButton.layer.cornerRadius = layer.cornerRadius
        selectDraftButton.clipsToBounds = true
        addSubview(selectDraftButton)
        
        questionLabel = UILabel()
        questionLabel.font = ._18SemiboldFont
        questionLabel.textAlignment = .left
        questionLabel.backgroundColor = .clear
        questionLabel.textColor = .white
        questionLabel.numberOfLines = 2
        questionLabel.lineBreakMode = .byTruncatingTail
        addSubview(questionLabel)
        
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
    
    @objc func selectDraftButtonPressed() {
        delegate?.draftCellDidSelectDraft(draft: draft)
    }
    
    func setupConstraints() {
        borderView.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-borderViewPadding * 2)
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        selectDraftButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        questionLabel.snp.makeConstraints { make in
            make.width.equalTo(borderView.snp.width).inset(questionLabelHorizontalPadding + editImageViewWidth)
            make.height.equalToSuperview()
            make.left.equalTo(borderView.snp.left).offset(questionLabelHorizontalPadding)
            make.centerY.equalToSuperview()
        }
        
        editImageView.snp.makeConstraints { make in
            make.width.equalTo(editImageViewWidth)
            make.right.equalTo(borderView.snp.right).inset(questionLabelHorizontalPadding)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }   

}
