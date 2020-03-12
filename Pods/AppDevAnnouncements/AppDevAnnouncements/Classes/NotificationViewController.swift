//
//  NotificationViewController.swift
//  AppDevAnnouncements
//
//  Created by Gonzalo Gonzalez on 3/11/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

internal class NotificationViewController: UIViewController {

    /// Components
    var notificationView: NotificationView!

    /// Initializer variables
    var announcement: Announcement

    init(announcement: Announcement) {
        self.announcement = announcement
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        notificationView = NotificationView(announcement: announcement, dismissFunc: #selector(dismissNotification), actionFunc: #selector(performCTA), target: self)
        notificationView.translatesAutoresizingMaskIntoConstraints = false
        notificationView.layer.cornerRadius = 10
        notificationView.clipsToBounds = true
        view.addSubview(notificationView)

        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            notificationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notificationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            notificationView.heightAnchor.constraint(equalToConstant: notificationView.getTotalHeight(announcement)),
            notificationView.widthAnchor.constraint(equalToConstant: NotificationView.Constants.notificationViewWidth)
        ])
    }

    @objc func dismissNotification() {
        dismiss(animated: true, completion: nil)
    }

    /// Executes the CTA. The currently supported CTAs are:
    /// - URLs
    @objc func performCTA() {
        guard let url = URL(string: announcement.ctaAction) else { return }
        UIApplication.shared.open(url)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - UIViewController+Extension for notification presentation

public extension UIViewController {

    func presentAnnouncement(completion: ((Bool) -> Void)?) {
        AnnouncementNetworking.retrieveAnnouncements { announcements in
            // Find first announcment that has yet to be presented to user
            let userDefaults = UserDefaults.standard
            let presentedAnnouncementIDsKey = "presentedAnnouncementIDs"

            let presentedAnnouncementIDs = userDefaults.value(forKey: presentedAnnouncementIDsKey) as? [Int] ?? []

            if let announcement = announcements.first(where: { !presentedAnnouncementIDs.contains($0.id) }) {
                userDefaults.set(presentedAnnouncementIDs + [announcement.id], forKey: presentedAnnouncementIDsKey)
                DispatchQueue.main.async {
                    let notificationVC = NotificationViewController(announcement: announcement)
                    self.present(notificationVC, animated: true)
                    completion?(true)
                }
            } else {
                completion?(false)
            }
        }
    }
    
}
