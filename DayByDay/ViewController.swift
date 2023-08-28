//
//  ViewController.swift
//  DayByDay
//
//  Created by FUTURE on 2023/08/28.
//

import UIKit

class ViewController: UIViewController {
    
    let backgroundImageView = UIImageView()
    let titleLabel = UILabel()
    let colorsimageViews = [UIImageView(), UIImageView(), UIImageView()]
    let imageUrls = [
        "https://i.ibb.co/cDVB83q/background-daytime.png",
        "https://i.ibb.co/5khdtP0/background-night.png",
        "https://i.ibb.co/9YKJ39W/background-twilight.png"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundImageView()
        setupTitleLabel()
        setupImageViews()
        setupConstraints()
    }
    
    private func setupBackgroundImageView() {
        backgroundImageView.frame = self.view.bounds
        backgroundImageView.image = UIImage(named: "backgroundImage")
        backgroundImageView.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImageView)
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Choose Your Mood"
        titleLabel.textColor = .white.withAlphaComponent(0.8)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .light)
        self.view.addSubview(titleLabel)
    }
    
    private func setupImageViews() {
        for (index, imageView) in colorsimageViews.enumerated() {
            imageView.tag = index
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 25
            imageView.clipsToBounds = true
            
            loadImage(for: imageView, with: imageUrls[index])
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            imageView.addGestureRecognizer(tapGesture)
            imageView.isUserInteractionEnabled = true
            self.view.addSubview(imageView)
        }
    }
    
    private func loadImage(for imageView: UIImageView, with urlString: String) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }
            }.resume()
        }
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 60)
        ])
        
        for (index, imageView) in colorsimageViews.enumerated() {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 50),
                imageView.heightAnchor.constraint(equalToConstant: 50),
                imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: CGFloat(20 + (60 * index)))
            ])
        }
    }
    
    @objc private func imageTapped(_ sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView {
            loadImage(for: backgroundImageView, with: imageUrls[imageView.tag])
            print("Image \(String(describing: imageView.image)) tapped")
        }
    }
}

