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
    var multipleChoiceButton: UIButton!
    var multipleChoiceLabel: UILabel!
    var separatorView: UIView!
    var freeResponseButton: UIButton!
    var freeResponseLabel: UILabel!
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
    let multipleChoiceLabelText: String = "Multiple Choice"
    let freeResponseLabelText: String = "Free Response"
    
    init(frame: CGRect, delegate: QuestionTypeDropDownViewDelegate, selectedQuestionType: QuestionType) {
        self.delegate = delegate
        self.selectedQuestionType = selectedQuestionType
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = .white
        
        multipleChoiceButton = UIButton()
        multipleChoiceButton.addTarget(self, action: #selector(didPickMultipleChoice), for: .touchUpInside)
        addSubview(multipleChoiceButton)
        
        multipleChoiceLabel = UILabel()
        multipleChoiceLabel.text = multipleChoiceLabelText
        multipleChoiceLabel.textAlignment = .center
        multipleChoiceLabel.textColor = selectedQuestionType == .multipleChoice ? .aquaMarine : .clickerBlack0
        multipleChoiceLabel.font = selectedQuestionType == .multipleChoice ? ._16SemiboldFont : ._16RegularFont
        addSubview(multipleChoiceLabel)
        
        freeResponseButton = UIButton()
        freeResponseButton.addTarget(self, action: #selector(didPickFreeResponse), for: .touchUpInside)
        addSubview(freeResponseButton)
        
        freeResponseLabel = UILabel()
        freeResponseLabel.text = freeResponseLabelText
        freeResponseLabel.textAlignment = .center
        freeResponseLabel.textColor = selectedQuestionType == .freeResponse ? .aquaMarine : .clickerBlack0
        freeResponseLabel.font = selectedQuestionType == .freeResponse ? ._16SemiboldFont : ._16RegularFont
        addSubview(freeResponseLabel)
        
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
        multipleChoiceButton.setBackgroundImage(backgroundImage, for: selectedQuestionType == .multipleChoice ? .normal : .highlighted)
        multipleChoiceButton.setBackgroundImage(UIImage(), for: selectedQuestionType == .multipleChoice ? .highlighted : .normal)
        freeResponseButton.setBackgroundImage(backgroundImage, for: selectedQuestionType == .freeResponse ? .normal : .highlighted)
        freeResponseButton.setBackgroundImage(UIImage(), for: selectedQuestionType == .freeResponse ? .highlighted : .normal)
        
        multipleChoiceButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(buttonHeight)
            make.top.equalToSuperview()
        }
        
        multipleChoiceLabel.snp.makeConstraints { make in
            make.width.equalTo(labelWidth)
            make.height.equalTo(multipleChoiceButton.snp.height)
            make.center.equalTo(multipleChoiceButton.snp.center)
        }
        
        freeResponseButton.snp.makeConstraints { make in
            make.width.equalTo(multipleChoiceButton.snp.width)
            make.height.equalTo(multipleChoiceButton.snp.height)
            make.top.equalTo(multipleChoiceButton.snp.bottom)
        }
        
        freeResponseLabel.snp.makeConstraints { make in
            make.width.equalTo(multipleChoiceLabel.snp.width)
            make.height.equalTo(multipleChoiceLabel.snp.height)
            make.center.equalTo(freeResponseButton.snp.center)
        }
        
        selectedImageView.snp.makeConstraints { make in
            make.width.height.equalTo(selectedImageViewLength)
            make.left.equalTo(selectedQuestionType == .multipleChoice ? multipleChoiceLabel.snp.right : freeResponseLabel.snp.right).inset(selectedImageViewInset)
            make.centerY.equalTo(selectedQuestionType == .multipleChoice ? multipleChoiceLabel.snp.centerY : freeResponseLabel.snp.centerY)
        }
        
        separatorView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(separatorHeight)
            make.center.equalToSuperview()
        }
        
    }
    
    @objc func didPickMultipleChoice() {
        delegate.questionTypeDropDownViewDidPick(questionType: .multipleChoice)
    }
    
    @objc func didPickFreeResponse() {
        delegate.questionTypeDropDownViewDidPick(questionType: .freeResponse)
    }

}
