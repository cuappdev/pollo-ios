//
//  AddCourseViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 11/5/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit
import SnapKit

class AddCourseViewController: UIViewController {
    
    var addCourseLabel: UILabel!
    var courseTextField: UITextField!
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        self.title = "Add Course"
        
        setupSubviews()
    }
    
    func setupSubviews() {
        addCourseLabel = UILabel()
        addCourseLabel.text = "Add Course"
        addCourseLabel.textColor = .black
        addCourseLabel.textAlignment = .center
        view.addSubview(addCourseLabel)
        
        addCourseLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-view.frame.height*0.1)
            make.width.equalTo(view.frame.width*0.5)
            make.height.equalTo(50)
        }
        
        courseTextField = UITextField()
        courseTextField.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1.0)
        courseTextField.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0)
        view.addSubview(courseTextField)
        
        courseTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(view.frame.width*0.6)
            make.height.equalTo(40)
        }
        
        
    }
    
}
