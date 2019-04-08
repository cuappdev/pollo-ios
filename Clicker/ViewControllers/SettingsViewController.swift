//
//  SettingsViewController.swift
//  Clicker
//
//  Created by eoin on 9/13/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import GoogleSignIn
import IGListKit
import UIKit

class SettingsViewController: UIViewController {

    // MARK: Views and VC's
    var adapter: ListAdapter!
    var collectionView: UICollectionView!
    var lineView: UIView!

    // MARK: Data
    var data: [ListDiffable]!
    
    // MARK: - Constants
    let about = "About"
    let aboutDescription = "Pollo is made by Cornell AppDev, an engineering project team at Cornell University."
    let account = "Account"
    let backButtonImageName = "darkexit"
    let feedbackDescription = "Let us know if you have any ideas, suggestions, or issues! Shake your phone to access the feedback form, or follow the link below."
    let logOut = "Log Out"
    let more = "More"
    let moreApps = "More Apps"
    let navBarTitle = "Settings"
    let privacyPolicy = "Privacy Policy"
    let sendUsFeedback = "Send Us Feedback"
    let submitFeedbackMessage = "You can help us make our app even better! Tap below to submit feedback."
    let submitFeedbackTitle = "Submit Feedback"
    let visitOurWebsite = "Visit Our Website"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = navBarTitle
        loadData()
        setupNavBar()
        setupViews()
        setupConstraints()
    }
    
    func loadData() {
        let settingsModel1 = SettingsDataModel(state: .info, title: account, description: User.currentUser?.email)
        let separatorLineModel1 = SeparatorLineModel(state: .settings)
        let settingsModel2 = SettingsDataModel(state: .info, title: about, description: aboutDescription)
        let settingsModel3 = SettingsDataModel(state: .link, title: moreApps, description: Links.allApps)
        let settingsModel4 = SettingsDataModel(state: .link, title: visitOurWebsite, description: Links.appDevSite)
        let separatorLineModel2 = SeparatorLineModel(state: .settings)
        let settingsDataModel5 = SettingsDataModel(state: .info, title: more, description: feedbackDescription)
        let settingsDataModel6 = SettingsDataModel(state: .link, title: sendUsFeedback, description: Links.feedbackForm)
        let settingsDataModel7 = SettingsDataModel(state: .link, title: privacyPolicy, description: Links.privacyPolicy)
        let settingsDataModel8 = SettingsDataModel(state: .button, title: logOut, description: logOut)
        
        data = [settingsModel1, separatorLineModel1, settingsModel2, settingsModel3, settingsModel4, separatorLineModel2, settingsDataModel5, settingsDataModel6, settingsDataModel7, settingsDataModel8]
    }

    func setupNavBar() {
        let gradientLayer = CAGradientLayer()
        
        var bounds = navigationController?.navigationBar.bounds ?? CGRect()
        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.clickerGrey7.cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        navigationController?.navigationBar.setBackgroundImage(image(fromLayer: gradientLayer), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let backImage = UIImage(named: backButtonImageName)?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .done, target: self, action: #selector(goBack))
        navigationItem.title = "Settings"
    
    }
    
    func setupViews() {
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        view.addSubview(collectionView)
        
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    
    }
    
    func setupConstraints() {
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(61)
        }
        
    }
    
    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
    
    // MARK: Actions
    @objc func logOutAction() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("cannot log out without AppDelegate!")
            return
        }
        self.dismiss(animated: true, completion: nil)
        appDelegate.logout()
        Analytics.shared.log(with: SignedOutPayload())
    }
    
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }

    // MARK: - Shake to send feedback
    open override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let alert = createAlert(title: submitFeedbackTitle, message: submitFeedbackMessage)
            alert.addAction(UIAlertAction(title: submitFeedbackTitle, style: .default, handler: { _ in
                let feedbackVC = FeedbackViewController(type: .settingsViewController)
                self.navigationController?.pushViewController(feedbackVC, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

}

extension SettingsViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is SettingsDataModel {
            return SettingsSectionController(delegate: self)
        } else {
            return SeparatorLineSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

extension SettingsViewController: LogOutSectionControllerDelegate {
    
    func logOutSectionControllerButtonWasTapped() {
        logOutAction()
    }
    
}
