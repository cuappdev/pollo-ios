//
//  ExpandedViewController.swift
//  Clicker
//
//  Created by eoin on 5/2/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class ExpandedViewController: UIViewController {

    var expandedCard: ExpandedAskedCard!
    var xButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setup() {
        view.backgroundColor = .clickerDeepBlack
        
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        expandedCard = ExpandedAskedCard()
        view.addSubview(expandedCard)
        
        xButton = UIButton(type: .roundedRect)
        xButton.setImage(UIImage(named: "whiteExit"), for: .normal)
        xButton.backgroundColor = .clear
        xButton.clipsToBounds = true
        xButton.layer.cornerRadius = 18.5
        xButton.layer.borderWidth = 2
        xButton.layer.borderColor = UIColor.white.cgColor
        xButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
        view.addSubview(xButton)
    }
    
    func setupConstraints() {
        xButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(37)
            make.width.equalTo(37)
            make.bottom.equalToSuperview().inset(19)
        }
        
        expandedCard.snp.makeConstraints { make in
            make.height.equalTo(531.5)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(75)
        }
    }
    
    @objc func exit() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
