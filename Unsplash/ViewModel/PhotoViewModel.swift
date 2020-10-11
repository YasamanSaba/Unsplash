//
//  PhotoViewModel.swift
//  Unsplash
//
//  Created by Yasaman Farahani Saba on 10/7/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class PhotoViewModel: NSObject {
    // MARK: - Properties
    var photoService: PhotoServiceType
    typealias PhotoDataSource = UICollectionViewDiffableDataSource<Int, ImageItem>
    var photoDataSource: PhotoDataSource?
    var photoCollectionView: UICollectionView?
    typealias RandomPhotoDataSource = UICollectionViewDiffableDataSource<Int, PhotoItem>
    var randomPhotoDataSource: RandomPhotoDataSource?
    var randomCollectionView: UICollectionView?
    var lastPhotoPage = 0
    var photos: [ImageItem] = []
    private lazy var itemWidth: CGFloat = {
        if let photoCollectionView = photoCollectionView {
            let insets = photoCollectionView.contentInset
            let width = (photoCollectionView.bounds.width - (insets.left + insets.right)) / 2
            return width
        } else {
            return 0
        }
    }()
    
    // MARK: - Initializer
    init(photoService: PhotoServiceType) {
        self.photoService = photoService
        super.init()
        self.photoService.delegate = self
    }
    
    // MARK: - Functions
    func start(photoCollectionView: UICollectionView) {
        self.photoCollectionView = photoCollectionView
        self.photoCollectionView?.delegate = self
        configPhoto(collectionView: photoCollectionView)
        self.photoService.fetchPhotos(at: 0)
        if let layout = photoCollectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }
    func configPhoto(collectionView: UICollectionView) {
        self.photoDataSource = PhotoDataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, item: ImageItem) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseId, for: indexPath) as? PhotoCollectionViewCell else { return nil }
            cell.photo = item
            if item.img == nil {
                self.photoService.fetchImage(by: item.url) { data in
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                        item.img = UIImage(data: data)
                        if let photoDataSource = self.photoDataSource {
                            var snapshot = photoDataSource.snapshot()
                            snapshot.reloadItems([item])
                            photoDataSource.apply(snapshot)
                        }
                    }
                }
            }
            return cell
        }
    }
    func giveRandomPhoto(width: Int, onComplete: @escaping (UIImage, UIColor) -> ()) {
        self.photoService.fetchRandomPhoto(width: width) { data, color in
            guard let data = data, let image = UIImage(data: data), let color = color else { return }
            let randomColor = UIColor(hexString: color)
            onComplete(image, randomColor)
        }
    }
}
// MARK: - Extensions
extension PhotoViewModel: PhotoServiceTypeDelegate {
    func fetched(photos: [PhotoItem]) {
        photos.forEach { photo in
            let color = UIColor(hexString: photo.color ?? "#ffffff")
            let desc = photo.desc ?? "No description available"
            let url = URL(string: photo.rawURL != nil ? photo.rawURL!.absoluteString + "&w=\(itemWidth)" : "")!
            let height = (Int32(itemWidth) * photo.height) / photo.width
            let image = ImageItem(color: color, desc: desc, img: nil, url: url, height: CGFloat(height))
            self.photos.append(image)
        }
        var snapshot = NSDiffableDataSourceSnapshot<Int, ImageItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(self.photos, toSection: 0)
        photoDataSource?.apply(snapshot)
        //photoCollectionView?.collectionViewLayout.prepare()
    }
}
extension PhotoViewModel: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        return photos[indexPath.row].height
    }
}

extension PhotoViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 2 {
            lastPhotoPage += 1
            photoService.fetchPhotos(at: lastPhotoPage)
            
        }
    }
}
