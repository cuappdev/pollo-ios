//
//  DropDownView.swift
//  Clicker
//
//  Created by eoin on 5/4/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol QuestionTypeDropDownViewDelegate: class {
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
    var centerView: UIView!
    
    // MARK: - Data vars
    weak var delegate: QuestionTypeDropDownViewDelegate?
    var selectedQuestionType: QuestionType!
    
    // MARK: - Constants
    let labelWidth: CGFloat = 150
    let buttonHeight: CGFloat = 53
    let centerViewWidth: CGFloat = 135
    let centerViewHeight: CGFloat = 24
    let selectedImageViewWidth: CGFloat = 13
    let selectedImageViewHeight: CGFloat = 13
    let selectedImageViewInset: CGFloat = 5.0
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
        
        centerView = UIView()
        addSubview(centerView)
        
        topLabel = UILabel()
        topLabel.text = selectedQuestionType == .multipleChoice ? multipleChoiceText : freeResponseText
        topLabel.textAlignment = .center
        topLabel.textColor = .clickerGreen0
        topLabel.font = ._16SemiboldFont
        centerView.addSubview(topLabel)
        
        selectedImageView = UIImageView()
        selectedImageView.image = UIImage(named: "DropUpArrowIcon")
        selectedImageView.tintColor = UIColor.clickerGreen1
        selectedImageView.contentMode = .scaleAspectFit
        centerView.addSubview(selectedImageView)
        
        bottomButton = UIButton()
        bottomButton.addTarget(self, action: #selector(didTapBottomButton), for: .touchUpInside)
        addSubview(bottomButton)
        
        bottomLabel = UILabel()
        bottomLabel.text = selectedQuestionType == .multipleChoice ? freeResponseText : multipleChoiceText
        bottomLabel.textAlignment = .center
        bottomLabel.textColor = .clickerBlack0
        bottomLabel.font = ._16RegularFont
        addSubview(bottomLabel)
        
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
        
        centerView.snp.makeConstraints { make in
            make.center.equalTo(topButton.snp.center)
            make.width.equalTo(centerViewWidth)
            make.height.equalTo(centerViewHeight)
        }
        
        topLabel.snp.makeConstraints { make in
            make.centerY.leading.height.equalToSuperview()
        }
        
        selectedImageView.snp.makeConstraints { make in
            make.width.equalTo(selectedImageViewWidth)
            make.height.equalTo(selectedImageViewHeight)
            make.centerY.equalTo(topLabel.snp.centerY)
            make.leading.equalTo(topLabel.snp.trailing).offset(selectedImageViewInset)
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
