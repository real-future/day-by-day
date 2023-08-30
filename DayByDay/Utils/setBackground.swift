//
//  setBackground.swift
//  DayByDay
//
//  Created by FUTURE on 2023/08/31.
//

import UIKit

public func setupBackground(for viewController: UIViewController) {
    let backgroundImageView = UIImageView(frame: viewController.view.bounds)
    backgroundImageView.contentMode = .scaleAspectFit
    
    if let selectedBackgroundImageURL = UserDefaults.standard.string(forKey: "selectedBackgroundImage") {
        print("Selected background URL: \(selectedBackgroundImageURL)")
        let url = URL(string: selectedBackgroundImageURL)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let error = error {
                print("Data task error: \(error)")
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        backgroundImageView.image = image
                        viewController.view.addSubview(backgroundImageView)
                        viewController.view.sendSubviewToBack(backgroundImageView)
                    }
                }
            }
        }.resume()
    } else {
        print("No selected background image in UserDefaults.")
    }
}

