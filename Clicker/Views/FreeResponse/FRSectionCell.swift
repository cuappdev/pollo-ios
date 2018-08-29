//
//  FRSectionCell.swift
//  Clicker
//
//  Created by Jack Schluger on 3/15/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//
 
import SnapKit
import UIKit
import Presentr

class FRSectionCell: QuestionSectionCell {
    
    let popupViewHeight: CGFloat = 95
    
    var session: Session!
    var grayViewBottomConstraint: Constraint!
    var questionDelegate: QuestionDelegate!
    
    var questionTextField: UITextField!
    var line: UIView!
    var responseOptionsLabel: UILabel!
    var changeButton: UIButton!
    
    // MARK: - INITIALIZATION
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layoutSubviews()
    }
    
    // MARK: - LAYOUT
    func setupViews() {
        questionTextField = UITextField()
        questionTextField.attributedPlaceholder = NSAttributedString(string: "Ask a question...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.clickerMediumGrey, NSAttributedStringKey.font: UIFont._18RegularFont])
        questionTextField.font = ._18RegularFont
        questionTextField.returnKeyType = .done
        questionTextField.delegate = self
        addSubview(questionTextField)
        
        line = UIView()
        line.backgroundColor = .clickerMediumGrey
        addSubview(line)
        
        responseOptionsLabel = UILabel()
        responseOptionsLabel.text = "Only you will see responses and votes"
        responseOptionsLabel.textAlignment = .left
        responseOptionsLabel.font = ._14MediumFont
        addSubview(responseOptionsLabel)
        
        changeButton = UIButton()
        changeButton.setTitle("Change", for: .normal)
        changeButton.titleLabel?.font = ._14MediumFont
        changeButton.titleLabel?.textColor = .clickerBlue
        changeButton.backgroundColor = .clear
        changeButton.titleLabel?.frame = changeButton.frame
        changeButton.addTarget(self, action: #selector(changeButtonPressed), for: .touchUpInside)
        addSubview(changeButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        questionTextField.snp.updateConstraints{ make in
            make.size.equalTo(CGSize(width: frame.width, height: 48))
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        line.snp.updateConstraints { make in
            make.height.equalTo(1.5)
            make.width.equalTo(339)
            make.centerX.equalToSuperview()
            make.top.equalTo(questionTextField.snp.bottom).offset(73.5)
        }
        
        responseOptionsLabel.snp.updateConstraints { make in
            responseOptionsLabel.sizeToFit()
            make.left.equalToSuperview().offset(35.5)
            make.top.equalTo(line.snp.bottom).offset(14)
        }
        
        changeButton.snp.updateConstraints { make in
            changeButton.sizeToFit()
            make.top.equalTo(responseOptionsLabel.snp.top)
            make.right.equalToSuperview().inset(47.5)
        }
    }
    
    @objc func changeButtonPressed() {
        let width = ModalSize.full
        let height = ModalSize.custom(size: Float(popupViewHeight))
        let originY = 0
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: originY))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let presenter: Presentr = Presentr(presentationType: customType)
        presenter.transitionType = TransitionType.coverVerticalFromTop
        presenter.backgroundOpacity = 0.6
        presenter.roundCorners = false
        presenter.dismissOnSwipe = true
        presenter.dismissOnTap = true
        presenter.dismissOnSwipeDirection = .top
        presenter.backgroundOpacity = 0.4
        
        let pickQTypeVC = PickQTypeViewController()
        pickQTypeVC.currentType = .multipleChoice // ToDo: actually set this to MULTIPLE_CHOICE or FREE_RESPONSE based on q type
        pickQTypeVC.setup()
        pickQTypeVC.popupHeight = popupViewHeight
        UIViewController().customPresentViewController(presenter, viewController: pickQTypeVC, animated: true, completion: nil)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


