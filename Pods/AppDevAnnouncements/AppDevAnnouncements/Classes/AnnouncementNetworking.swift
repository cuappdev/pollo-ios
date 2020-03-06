//
//  AnnouncementNetworking.swift
//  AppDevAnnouncements
//
//  Created by Gonzalo Gonzalez on 11/17/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit

public class AnnouncementNetworking {

    static private var announcementURL: URL?

    static public func setupConfig(scheme: String, host: String, commonPath: String, announcementPath: String) {
        if(!scheme.isEmpty && !host.isEmpty && !commonPath.isEmpty && !announcementPath.isEmpty) {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = "\(commonPath)\(announcementPath)"
            announcementURL = components.url
        }
    }

    static internal func retrieveAnnouncements(completion: @escaping (([Announcement]) -> Void)) {
        guard let announcementURL = announcementURL else {
            print("Did not setup config properly")
            return
        }

        URLSession.shared.dataTask(with: announcementURL) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else { return }

            let jsonDecoder = JSONDecoder()
            if let apiResponse = try? jsonDecoder.decode(Response<[Announcement]>.self, from: data) {
                completion(apiResponse.data)
            }
        }.resume()
    }

}

internal extension UIImageView {

    func loadFrom(url: String, completion: ((Bool) -> Void)?) {
        guard let url = URL(string: url) else {
            completion?(false)
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let unwrappedData = data {
            DispatchQueue.main.async() { self.image = UIImage(data: unwrappedData) }
                completion?(true)
            } else if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
                completion?(false)
            } else {
                completion?(false)
            }
        }.resume()
    }

}
