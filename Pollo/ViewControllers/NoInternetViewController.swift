//
//  NoInternetViewController.swift
//  Pollo
//
//  Created by Gonzalo Gonzalez on 3/22/20.
//  Copyright © 2020 CornellAppDev. All rights reserved.
//

import UIKit
import GoogleSignIn

class NoInternetViewController: UIViewController {
    
    // MARK: - View vars
    let descriptionLabel = UILabel()
    let facepalmImageView = UIImageView()
    let retryButton = UIButton()
    let titleLabel = UILabel()
    
    // MARK: - Constants
    let descriptionLabelHeight: CGFloat = 12
    let descriptionLabelText = "No Internet Connection"
    let descriptionLabelTopPadding: CGFloat = 5
    let facepalmImage = UIImage(named: "woman_facepalming")
    let facepalmImageViewBottomPadding: CGFloat = 16
    let facepalmImageViewWidth: CGFloat = 60
    let retryButtonBorderWidth: CGFloat = 2.5
    let retryButtonCornerRadius: CGFloat = 20
    let retryButtonHeight: CGFloat = 35
    let retryButtonText = "Retry"
    let retryButtonTopPadding: CGFloat = 16
    let retryButtonWidth: CGFloat = 197
    let titleLabelHeight: CGFloat = 28
    let titleLabelText = "Oops"
    
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
        descriptionLabel.textColor = .lightGrey
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
            GIDSignIn.sharedInstance().signInSilently()
        }
        self.navigationController?.popViewController(animated: false)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
