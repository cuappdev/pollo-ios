//
//  DropDownView.swift
//  Clicker
//
//  Created by eoin on 5/4/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol QuestionTypeDropDownViewDelegate {
    func questionTypeDropDownViewDidPick(questionType: QuestionType)
}

class QuestionTypeDropDownView: UIView {
    
    // MARK: - View vars
    var topButton: UIButton!
    var topLabel: UILabel!
    var separatorView: UIView!
    var bottomButton: UIButton!
    var bottomLabel: UILabel!
    var selectedImageView: UIImageView!
    var selectedGradient: CAGradientLayer!
    
    // MARK: - Data vars
    var delegate: QuestionTypeDropDownViewDelegate!
    var selectedQuestionType: QuestionType!
    
    // MARK: - Constants
    let labelWidth: CGFloat = 150
    let buttonHeight: CGFloat = 50
    let selectedImageViewLength: CGFloat = 6.5
    let selectedImageViewInset: CGFloat = 5
    let separatorHeight: CGFloat = 2
    let multipleChoiceText: String = "Multiple Choice"
    let freeResponseText: String = "Free Response"
    
    init(frame: CGRect, delegate: QuestionTypeDropDownViewDelegate, selectedQuestionType: QuestionType) {
        super.init(frame: frame)
        self.delegate = delegate
        self.selectedQuestionType = selectedQuestionType
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = .white
        
        topButton = UIButton()
        topButton.addTarget(self, action: #selector(didTapTopButton), for: .touchUpInside)
        addSubview(topButton)
        
        topLabel = UILabel()
        topLabel.text = selectedQuestionType == .multipleChoice ? multipleChoiceText : freeResponseText
        topLabel.textAlignment = .center
        topLabel.textColor = .aquaMarine
        topLabel.font = ._16SemiboldFont
        addSubview(topLabel)
        
        bottomButton = UIButton()
        bottomButton.addTarget(self, action: #selector(didTapBottomButton), for: .touchUpInside)
        addSubview(bottomButton)
        
        bottomLabel = UILabel()
        bottomLabel.text = selectedQuestionType == .multipleChoice ? freeResponseText : multipleChoiceText
        bottomLabel.textAlignment = .center
        bottomLabel.textColor = .clickerBlack0
        bottomLabel.font = ._16RegularFont
        addSubview(bottomLabel)
        
        selectedImageView = UIImageView()
        selectedImageView.image = #imageLiteral(resourceName: "DropUpArrowIcon")
        addSubview(selectedImageView)
        
        selectedGradient = CAGradientLayer()
        selectedGradient.frame = CGRect(x: 0, y: 0, width: bounds.width, height: buttonHeight)
        selectedGradient.colors = [UIColor.white.cgColor, UIColor.clickerGrey7.cgColor, UIColor.white.cgColor]
        selectedGradient.startPoint = CGPoint(x: 0, y: 0)
        selectedGradient.endPoint = CGPoint(x: 1, y: 0)
        
        separatorView = UIView()
        separatorView.backgroundColor = .clickerGrey8
        addSubview(separatorView)
        
        setupConstraints()
    }
    
    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        let backgroundImage: UIImage = image(fromLayer: selectedGradient)
        topButton.setBackgroundImage(backgroundImage, for: .normal)
        topButton.setBackgroundImage(UIImage(), for: .highlighted)
        bottomButton.setBackgroundImage(backgroundImage, for: .highlighted)
        bottomButton.setBackgroundImage(UIImage(), for: .normal)
        
        topButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(buttonHeight)
            make.top.equalToSuperview()
        }
        
        topLabel.snp.makeConstraints { make in
            make.width.equalTo(labelWidth)
            make.height.equalTo(topButton.snp.height)
            make.center.equalTo(topButton.snp.center)
        }
        
        bottomButton.snp.makeConstraints { make in
            make.width.equalTo(topButton.snp.width)
            make.height.equalTo(topButton.snp.height)
            make.top.equalTo(topButton.snp.bottom)
        }
        
        bottomLabel.snp.makeConstraints { make in
            make.width.equalTo(topLabel.snp.width)
            make.height.equalTo(topLabel.snp.height)
            make.center.equalTo(bottomButton.snp.center)
        }
        
        selectedImageView.snp.makeConstraints { make in
            make.width.height.equalTo(selectedImageViewLength)
            make.left.equalTo(topLabel.snp.right).inset(selectedImageViewInset)
            make.centerY.equalTo(topLabel.snp.centerY)
        }
        
        separatorView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(separatorHeight)
            make.center.equalToSuperview()
        }
        
    }
    
    @objc func didTapTopButton() {
        delegate.questionTypeDropDownViewDidPick(questionType: selectedQuestionType)
    }
    
    @objc func didTapBottomButton() {
        delegate.questionTypeDropDownViewDidPick(questionType: selectedQuestionType.other)
    }

}
