//
//  AddCourseViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 11/5/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit

class AddCourseViewController: UIViewController {
    
//    var addCourseLabel: UILabel!
    var courseTextField: UITextField!
    var addCourseButton: UIButton!
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        self.title = "Add Course"
        
        setupSubviews()
    }
    
    func setupSubviews() {
//        addCourseLabel = UILabel()
//        addCourseLabel.text = "Add Course"
//        addCourseLabel.textColor = .black
//        addCourseLabel.textAlignment = .center
//        view.addSubview(addCourseLabel)
        
//        addCourseLabel.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview().offset(-view.frame.height*0.1)
//            make.width.equalTo(view.frame.width*0.5)
//            make.height.equalTo(50)
//        }
        
        courseTextField = UITextField()
        courseTextField.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1.0)
        courseTextField.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0)
        courseTextField.textAlignment = .center
        view.addSubview(courseTextField)
        
        courseTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(view.frame.width*0.6)
            make.height.equalTo(40)
        }
        
        addCourseButton = UIButton()
        addCourseButton.setTitle("ENROLL", for: .normal)
        addCourseButton.titleLabel?.textColor = .white
        addCourseButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        addCourseButton.backgroundColor = .clickerBlue
        addCourseButton.layer.cornerRadius = 5
        addCourseButton.addTarget(self, action: #selector(addCourse), for: .touchUpInside)
        view.addSubview(addCourseButton)

        addCourseButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(view.frame.width*0.4)
            make.height.equalTo(60)
            make.top.equalTo(courseTextField.snp.bottom).offset(40)
        }
    }
    
    @objc func addCourse() {
        if let text = courseTextField.text {
//            let defaults = UserDefaults.standard
//            if defaults.value(forKey: "enrolledCourses") == nil {
//                var enrolledCourses = [text]
//                defaults.set(enrolledCourses, forKey: "enrolledCourses")
//
//            } else {
//                var enrolledCourses = defaults.value(forKey: "enrolledCourses") as? [String]
//                enrolledCourses?.append(text)
//                defaults.set(enrolledCourses, forKey: "enrolledCourses")
//            }
            
            // USE USER DEFAULTS???
            
            CourseAddStudents(id: text, studentIDs: ["1"]).make()
                .then {
                    print("added student")
                } .catch { error in
                    print(error)
                }
            courseTextField.text = ""
            self.navigationController?.popViewController(animated: true)
        }
    }
}
