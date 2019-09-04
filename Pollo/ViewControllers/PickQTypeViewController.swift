//
//  ViewController.swift
//  Pollo
//
//  Created by eoin on 4/27/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

protocol PickQTypeDelegate: class {
    func updateQuestionType(_ type: QuestionType)
}

class PickQTypeViewController: UIViewController {

    var bottomBackgroundView: UIButton!
    var currentType: QuestionType! 
    var popupHeight: CGFloat!
    var topBackgroundView: UIButton!
    weak var delegate: PickQTypeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    func setup() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        topBackgroundView = UIButton()
        topBackgroundView.backgroundColor = .clear
        topBackgroundView.addTarget(self, action: #selector(topPressed), for: .touchUpInside)
        view.addSubview(topBackgroundView)
        
        bottomBackgroundView = UIButton()
        bottomBackgroundView.backgroundColor = .clickerWhite
        bottomBackgroundView.setTitle(currentType.description, for: .normal)
        bottomBackgroundView.setTitleColor(.clickerBlack0, for: .normal)
        bottomBackgroundView.titleLabel?.font = ._16SemiboldFont
        bottomBackgroundView.addTarget(self, action: #selector(bottomPressed), for: .touchUpInside)
        view.addSubview(bottomBackgroundView)
    }
    
    func setupConstraints() {
        topBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            
        }
        
        bottomBackgroundView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            
        }
        
    }
    
    // MARK: - ACTIONS
    
    @objc func topPressed() {
        delegate?.updateQuestionType(currentType)
    }
    
    @objc func bottomPressed() {
        delegate?.updateQuestionType((currentType == .multipleChoice) ? .freeResponse : .multipleChoice)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
