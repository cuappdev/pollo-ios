//
//  PollPreviewCell.swift
//  Clicker
//
//  Created by eoin on 4/16/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol PollPreviewCellDelegate {
    
    func shouldEditPoll(atIndex index: Int)

}

class PollPreviewCell: UITableViewCell {
    
    var session: Session!
    var index: Int!
    var delegate: PollPreviewCellDelegate!
    
    var nameLabel: UILabel!
    var codeLabel: UILabel!
    var line: UIView!
    var dotsButton: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    // MARK - Layout
    func setupViews() {
        nameLabel = UILabel()
        nameLabel.font = ._18SemiboldFont
        contentView.addSubview(nameLabel)
    
        codeLabel = UILabel()
        codeLabel.font = ._18MediumFont
        codeLabel.textColor = .clickerMediumGrey
        contentView.addSubview(codeLabel)
        
        line = UIView()
        line.backgroundColor = .clickerBorder
        contentView.addSubview(line)
        
        dotsButton = UIButton()
        dotsButton.setImage(#imageLiteral(resourceName: "dots"), for: .normal)
        dotsButton.addTarget(self, action: #selector(dotsBtnPressed), for: .touchUpInside)
        dotsButton.clipsToBounds = true
        contentView.addSubview(dotsButton)
    }
    
    func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(19.5)
            make.height.equalTo(21.5)
            make.width.equalTo(300)
            make.left.equalToSuperview().offset(17)
        }
        
        codeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.height.equalTo(17)
            make.left.equalTo(nameLabel.snp.left)
            make.width.equalTo(nameLabel.snp.width)
        }
        
        line.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.equalToSuperview().offset(18)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        dotsButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc func dotsBtnPressed() {
        delegate.shouldEditPoll(atIndex: index)
    }
    
    func updateLabels() {
        nameLabel.text = session.name
        codeLabel.text = "CODE: \(session.code)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
