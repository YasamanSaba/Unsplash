//
//  imageCollectionViewCell.swift
//  Unsplash
//
//  Created by Yasaman Farahani Saba on 9/29/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    static let reuseId = String(describing: ImageCollectionViewCell.self)
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(containerView)
        return containerView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageView)
        return imageView
    }()
    
    
    
    lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.numberOfLines = 1
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = false
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = false
        self.contentView.addSubview(label)
        return label
    }()
    
    override func awakeFromNib() {
      super.awakeFromNib()
      containerView.layer.cornerRadius = 6
      containerView.layer.masksToBounds = true
    }
    
    var photo: PhotoItem? {
      didSet {
        if let photo = photo {
//          imageView.image = photo.image
//          captionLabel.text = photo.caption
//          commentLabel.text = photo.comment
        }
      }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 4/5),
            captionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 3),
            captionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 3),
            captionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -3),
            commentLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 2),
            commentLabel.leadingAnchor.constraint(equalTo: captionLabel.leadingAnchor),
            commentLabel.trailingAnchor.constraint(equalTo: captionLabel.trailingAnchor),
            commentLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -2)
        ])
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }
}
