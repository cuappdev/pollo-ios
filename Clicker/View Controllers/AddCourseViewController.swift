//
//  AddCourseViewController.swift
//  Clicker
//
//  Created by Kevin Chan on 11/5/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SnapKit

class AddCourseViewController: UIViewController {
    
    var addCourseLabel: UILabel!
    var courseTextField: UITextField!
    var errorLabel: UILabel!
    var addCourseButton: UIButton!
    
    var tapGestureRecognizer: UITapGestureRecognizer?
    var panGestureRecognizer: UIPanGestureRecognizer?
    var originalPosition: CGPoint?
    var currentPositionTouched: CGPoint?
    var touchLocation: CGPoint?
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        view.backgroundColor = .white
        setupSubviews()
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer!)
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(panGestureRecognizer!)
    }
    
    func setupSubviews() {
        addCourseLabel = UILabel()
        addCourseLabel.text = "What is your course code?"
        addCourseLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        addCourseLabel.textColor = .black
        addCourseLabel.textAlignment = .left
        view.addSubview(addCourseLabel)
        
        courseTextField = UITextField()
        courseTextField.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1.0)
        courseTextField.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0)
        courseTextField.textAlignment = .center
        view.addSubview(courseTextField)
        
        errorLabel = UILabel()
        errorLabel.text = "Invalid course code."
        errorLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        errorLabel.textColor = .clickerRed
        errorLabel.textAlignment = .center
        errorLabel.isHidden = true
        view.addSubview(errorLabel)
        
        addCourseButton = UIButton()
        addCourseButton.setTitle("Enroll", for: .normal)
        addCourseButton.titleLabel?.textColor = .white
        addCourseButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        addCourseButton.backgroundColor = .clickerBlue
        addCourseButton.layer.cornerRadius = 5
        addCourseButton.addTarget(self, action: #selector(addCourse), for: .touchUpInside)
        view.addSubview(addCourseButton)

        setConstraints()
    }
    
    // MARK: - CONSTRAINTS
    func setConstraints() {
        
        addCourseLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.width.equalTo(view.frame.width*0.8)
            make.height.equalTo(50)
        }
        
        courseTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(view.frame.width*0.8)
            make.height.equalTo(60)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(courseTextField.snp.bottom).offset(20)
            make.width.equalTo(view.frame.width*0.8)
        }
        
        addCourseButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(view.frame.width*0.8)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().offset(-100)
        }
    }

    // MARK: - ADD COURSE
    @objc func addCourse() {
        guard let courseCode = courseTextField.text else {
            return
        }
        // TODO: Figure out how to use JSONEncoding.default with Quarks
        let parameters: Parameters = [
            "courseCode": courseCode,
            "students": ["1"] // TEMP
        ]
        Alamofire.request("http://localhost:3000/api/v1/course/register/", method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            guard let data = response.data, let responseString = String(data: data, encoding: .utf8) else {
                print("response cant be parsed into JSON")
                return
            }
            let res = JSON(parseJSON: responseString)
            if let errors = res["data"]["errors"].array {
                self.errorLabel.isHidden = false
            } else {
                self.errorLabel.isHidden = true
            }
            if let significantEvents : Int = UserDefaults.standard.integer(forKey: "significantEvents"){
                UserDefaults.standard.set(significantEvents + 4, forKey:"significantEvents")
            }
            self.courseTextField.text = ""
            self.navigationController?.dismiss(animated: true)
        }
    }
    
    // MARK: - KEYBOARD
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - PANNING temp implementation, should generalize so other vc's can easily implement
    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: view)
        
        if panGesture.state == .began {
            originalPosition = view.center
            currentPositionTouched = panGesture.location(in: view)
        } else if panGesture.state == .changed {
            view.frame.origin = CGPoint(
                x: 0,
                y: translation.y > 0 ? translation.y : 0
            )
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: view)
            
            if velocity.y >= 1500 {
                UIView.animate(withDuration: 0.2
                    , animations: {
                        self.view.frame.origin = CGPoint(
                            x: self.view.frame.origin.x,
                            y: self.view.frame.size.height
                        )
                }, completion: { (isCompleted) in
                    if isCompleted {
                        self.dismiss(animated: false, completion: nil)
                    }
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.center = self.originalPosition!
                })
            }
        }
    }
}
