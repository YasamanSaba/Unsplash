//
//  imageCollectionViewCell.swift
//  Unsplash
//
//  Created by Yasaman Farahani Saba on 9/29/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = String(describing: PhotoCollectionViewCell.self)
        
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageView)
        return imageView
    }()
    lazy var descView: UIView = {
        let descView = UIView()
        descView.translatesAutoresizingMaskIntoConstraints = false
        descView.backgroundColor = .systemGray5
        self.contentView.addSubview(descView)
        return descView
    }()
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .label
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = false
        self.descView.addSubview(label)
        return label
    }()
    var photo: ImageItem? {
        didSet {
            if let photo = photo {
                self.contentView.backgroundColor = photo.color
                if let image = photo.img {
                    self.imageView.image = image
                }
                self.commentLabel.text = photo.desc
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: commentLabel.topAnchor),
            descView.heightAnchor.constraint(equalToConstant: 20),
            descView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            descView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            descView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            commentLabel.leadingAnchor.constraint(equalTo: descView.leadingAnchor, constant: 4),
            commentLabel.topAnchor.constraint(equalTo: descView.topAnchor, constant: 2),
            commentLabel.bottomAnchor.constraint(equalTo: descView.bottomAnchor, constant: -2),
            commentLabel.trailingAnchor.constraint(equalTo: descView.trailingAnchor, constant: -2)
        ])
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = true
    }
    override func prepareForReuse() {
        imageView.image = nil
        commentLabel.text = ""
    }
}
