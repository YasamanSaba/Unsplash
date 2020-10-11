//
//  PinterestLayout.swift
//  Unsplash
//
//  Created by Yasaman Farahani Saba on 9/30/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
    
    weak var delegate: PinterestLayoutDelegate?
    
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 2
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    // 1
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    // 2
    override func prepare() {
        guard let collectionView = collectionView else { return }
        cache.removeAll()
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        if collectionView.numberOfSections > 0 && collectionView.numberOfItems(inSection: 0) > 0 {
            for item in 0..<collectionView.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)
                
                let photoHeight = delegate?.collectionView(
                    collectionView, heightForPhotoAtIndexPath: indexPath) ?? 180
                let height = cellPadding * 2 + photoHeight
                let frame = CGRect(x: xOffset[column], y: yOffset[column],
                                   width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
                
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                
                column = column < (numberOfColumns - 1) ? (column + 1) : 0
            }
        }
    }
    // 3
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    // 4
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
