//
//  NoInternetViewController.swift
//  Pollo
//
//  Created by Gonzalo Gonzalez on 3/22/20.
//  Copyright © 2020 CornellAppDev. All rights reserved.
//

import UIKit

class NoInternetViewController: UIViewController {
    
    // MARK: - View vars
    private let descriptionLabel = UILabel()
    private let facepalmImageView = UIImageView()
    private let retryButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    
    // MARK: - Constants
    private let descriptionLabelHeight: CGFloat = 12
    private let descriptionLabelText = "No Internet Connection"
    private let descriptionLabelTopPadding: CGFloat = 5
    private let facepalmImage = UIImage(named: "woman_facepalming")
    private let facepalmImageViewBottomPadding: CGFloat = 16
    private let facepalmImageViewWidth: CGFloat = 60
    private let retryButtonBorderWidth: CGFloat = 2.5
    private let retryButtonCornerRadius: CGFloat = 20
    private let retryButtonHeight: CGFloat = 35
    private let retryButtonText = "Retry"
    private let retryButtonTopPadding: CGFloat = 16
    private let retryButtonWidth: CGFloat = 197
    private let titleLabelHeight: CGFloat = 28
    private let titleLabelText = "Oops"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        facepalmImageView.image = facepalmImage
        view.addSubview(facepalmImageView)
        
        titleLabel.text = titleLabelText
        titleLabel.textAlignment = .center
        titleLabel.font = ._30BoldFont
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        
        descriptionLabel.text = descriptionLabelText
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = ._16SemiboldFont
        descriptionLabel.textColor = .lightGray
        view.addSubview(descriptionLabel)
        
        retryButton.setTitle(retryButtonText, for: .normal)
        retryButton.setTitleColor(.polloGreen, for: .normal)
        retryButton.titleLabel?.font = ._16SemiboldFont
        retryButton.layer.borderWidth = retryButtonBorderWidth
        retryButton.layer.borderColor = UIColor.polloGreen.cgColor
        retryButton.layer.cornerRadius = retryButtonCornerRadius
        retryButton.addTarget(self, action: #selector(retryPressed), for: .touchUpInside)
        view.addSubview(retryButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(titleLabelHeight)
        }
        
        facepalmImageView.snp.makeConstraints { make in
            make.centerX.equalTo(titleLabel)
            make.bottom.equalTo(titleLabel.snp.top).offset(facepalmImageViewBottomPadding * -1)
            make.width.height.equalTo(facepalmImageViewWidth)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(descriptionLabelTopPadding)
            make.centerX.equalTo(titleLabel)
            make.height.equalTo(descriptionLabelHeight)
        }
        
        retryButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(retryButtonTopPadding)
            make.centerX.equalTo(descriptionLabel)
            make.height.equalTo(retryButtonHeight)
            make.width.equalTo(retryButtonWidth)
        }
    }
    
    @objc func retryPressed() {
        DispatchQueue.main.async {
            //GIDSignIn.sharedInstance().signInSilently()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
