//
//  ViewController.swift
//  Unsplash
//
//  Created by Yasaman Farahani Saba on 9/28/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Properties
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var photoViewModel: PhotoViewModel!
    lazy var randomImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemGray5
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        self.view.addSubview(image)
        return image
    }()
    lazy var imageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: PinterestLayout())
        self.view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    var timer: Timer?
    var randomImageHeight: NSLayoutConstraint?
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        randomImageHeight = NSLayoutConstraint(item: randomImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 100)
        NSLayoutConstraint.activate([
            randomImageHeight!,
            randomImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            randomImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            randomImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            randomImage.bottomAnchor.constraint(equalTo: imageCollectionView.topAnchor, constant: -5),
            imageCollectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            imageCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        let photoService = PhotoService(context: context)
        self.photoViewModel = PhotoViewModel(photoService: photoService)
        self.photoViewModel.start(photoCollectionView: imageCollectionView)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            self.photoViewModel.giveRandomPhoto(width: Int(self.randomImage.bounds.width)) { image, color in
                DispatchQueue.main.async {
                    self.randomImageHeight?.constant = image.size.height
                    UIView.animate(withDuration: 0.5) { [weak self] in
                        self?.view.layoutIfNeeded()
                    }
                    self.randomImage.image = image
                    self.randomImage.backgroundColor = color
                }
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
}
