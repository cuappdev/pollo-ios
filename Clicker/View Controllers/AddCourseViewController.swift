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
    
    var addCourseLabel: UILabel!
    var courseTextField: UITextField!
    var errorLabel: UILabel!
    var addCourseButton: UIButton!
    
    var tapGestureRecognizer: UITapGestureRecognizer?
    var panGestureRecognizer: UIPanGestureRecognizer?
    var originalPosition: CGPoint?
    var currentPositionTouched: CGPoint?
    var touchLocation: CGPoint?
    
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
        
        addCourseLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.width.equalTo(view.frame.width*0.8)
            make.height.equalTo(50)
        }
        
        courseTextField = UITextField()
        courseTextField.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1.0)
        courseTextField.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0)
        courseTextField.textAlignment = .center
        view.addSubview(courseTextField)
        
        courseTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(view.frame.width*0.8)
            make.height.equalTo(60)
        }
        
        errorLabel = UILabel()
        errorLabel.text = "Invalid course code."
        errorLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        errorLabel.textColor = .clickerRed
        errorLabel.textAlignment = .center
        errorLabel.isHidden = true
        view.addSubview(errorLabel)
        
        errorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(courseTextField.snp.bottom).offset(20)
            make.width.equalTo(view.frame.width*0.8)
        }
        
        addCourseButton = UIButton()
        addCourseButton.setTitle("ENROLL", for: .normal)
        addCourseButton.titleLabel?.textColor = .white
        addCourseButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        addCourseButton.backgroundColor = .clickerBlue
        addCourseButton.layer.cornerRadius = 5
        addCourseButton.addTarget(self, action: #selector(addCourse), for: .touchUpInside)
        view.addSubview(addCourseButton)

        addCourseButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(view.frame.width*0.8)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().offset(-100)
        }
    }
    
    @objc func addCourse() {
        if let text = courseTextField.text {
            CourseAddStudents(id: text, studentIDs: ["1"]).make() // TEMP: using "1" as id
                .then { Void -> Void in 
                }.catch { error in
                    print(error)
                    self.errorLabel.isHidden = false
                }
            courseTextField.text = ""
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
