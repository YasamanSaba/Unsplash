//
//  ViewController.swift
//  Unsplash
//
//  Created by Yasaman Farahani Saba on 9/28/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var photos: [PhotoItem] = [] //Photo.allPhotos()
    
    lazy var randomImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        //image.image = #imageLiteral(resourceName: "8")
        image.contentMode = .scaleToFill
        self.view.addSubview(image)
        return image
    }()
    
    //    func layoutCollectionView() -> UICollectionViewCompositionalLayout {
    //        let itemSize = NSCollectionLayoutSize(
    //          widthDimension: .fractionalWidth(1.0),
    //          heightDimension: .fractionalHeight(1.0))
    //        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
    //        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
    //        let groupSize = NSCollectionLayoutSize(
    //          widthDimension: .fractionalWidth(1.0),
    //          heightDimension: .fractionalWidth(1/3))
    //        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: fullPhotoItem, count: 2)
    //
    //        let section = NSCollectionLayoutSection(group: group)
    //
    //        let layout = UICollectionViewCompositionalLayout(section: section)
    //        return layout
    //    }
    
    lazy var imageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: PinterestLayout())
        self.view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = imageCollectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        imageCollectionView.dataSource = self
        NSLayoutConstraint.activate([
            randomImage.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/5),
            randomImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            randomImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            randomImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            randomImage.bottomAnchor.constraint(equalTo: imageCollectionView.topAnchor, constant: -5),
            imageCollectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            imageCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseId, for: indexPath as IndexPath) as! ImageCollectionViewCell
      cell.photo = photos[indexPath.item]
      return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
      return CGSize(width: itemSize, height: itemSize)
    }
}

extension ViewController: PinterestLayoutDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    return 10//photos[indexPath.item].image.size.height
  }
}
