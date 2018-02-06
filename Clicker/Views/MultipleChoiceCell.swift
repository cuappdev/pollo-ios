//
//  MultipleChoiceCell.swift
//  Clicker
//
//  Created by Kevin Chan on 2/5/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import SnapKit
import UIKit

class MultipleChoiceCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    var questionTextField: UITextField!
    var optionsViewArray = [MultipleChoiceOptionView]()
    var optionAView: MultipleChoiceOptionView!
    var optionBView: MultipleChoiceOptionView!
    var addMoreView: UIView!
    var plusLabel: UILabel!
    var addMoreLabel: UILabel!
    var startPollButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clickerBackground
        
        questionTextField = UITextField()
        questionTextField.placeholder = "Add Question"
        questionTextField.font = UIFont.systemFont(ofSize: 21)
        questionTextField.backgroundColor = .white
        questionTextField.layer.sublayerTransform = CATransform3DMakeTranslation(18, 0, 0)
        addSubview(questionTextField)
        
        optionAView = MultipleChoiceOptionView(frame: .zero, optionTag: 0)
        optionsViewArray.append(optionAView)
        addSubview(optionAView)
        
        optionBView = MultipleChoiceOptionView(frame: .zero, optionTag: 1)
        optionsViewArray.append(optionBView)
        addSubview(optionBView)
        
        addMoreView = UIView()
        addMoreView.backgroundColor = .clickerBackground
        addMoreView.layer.cornerRadius = 8
        addMoreView.layer.borderColor = UIColor.clickerBorder.cgColor
        addMoreView.layer.borderWidth = 0.5
        addSubview(addMoreView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addOption))
        tap.delegate = self
        addMoreView.addGestureRecognizer(tap)
        
        plusLabel = UILabel()
        plusLabel.text = "+"
        plusLabel.textColor = .clickerDarkGray
        plusLabel.textAlignment = .center
        plusLabel.font = UIFont.systemFont(ofSize: 20.5, weight: .semibold)
        addMoreView.addSubview(plusLabel)
        
        addMoreLabel = UILabel()
        addMoreLabel.text = "Add More"
        addMoreLabel.textColor = UIColor(red: 209/255, green: 212/255, blue: 223/255, alpha: 1.0)
        addMoreLabel.font = UIFont.systemFont(ofSize: 16)
        addMoreView.addSubview(addMoreLabel)
        
        startPollButton = UIButton()
        startPollButton.backgroundColor = .clickerBlue
        startPollButton.layer.cornerRadius = 8
        startPollButton.setTitle("Start Poll", for: .normal)
        startPollButton.setTitleColor(.white, for: .normal)
        startPollButton.titleLabel?.font = UIFont._18SemiboldFont
        addSubview(startPollButton)
        
        layoutSubviews()
    }
    
    @objc func addOption() {
        print("ADD OPTION")
//        let optionView = MultipleChoiceOptionView(frame: .zero, optionTag: optionsViewArray.count)
//        optionsViewArray.append(optionView)
//        addSubview(optionView)
//
//        optionView.snp.makeConstraints { make in
//            make.size.equalTo(optionAView.snp.size)
//            make.top.equalTo(optionsViewArray[optionsViewArray.count - 2].snp.bottom).offset(5)
//            make.centerX.equalToSuperview()
//        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        questionTextField.snp.updateConstraints{ make in
            make.size.equalTo(CGSize(width: frame.width, height: 61))
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        optionAView.snp.updateConstraints { make in
            make.size.equalTo(CGSize(width: frame.width * 0.904, height: 55))
            make.top.equalTo(questionTextField.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        optionBView.snp.updateConstraints { make in
            make.size.equalTo(optionAView.snp.size)
            make.top.equalTo(optionAView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        addMoreView.snp.updateConstraints { make in
            make.size.equalTo(optionAView.snp.size)
            make.top.equalTo(optionsViewArray[optionsViewArray.count - 2].snp.bottom).offset(65)
            make.centerX.equalToSuperview()
        }
        
        plusLabel.snp.updateConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.1268436578)
            make.height.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        addMoreLabel.snp.updateConstraints { make in
            make.left.equalTo(plusLabel.snp.right)
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        startPollButton.snp.updateConstraints { make in
            make.size.equalTo(optionAView.snp.size)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-18)
        }
    }
    
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
