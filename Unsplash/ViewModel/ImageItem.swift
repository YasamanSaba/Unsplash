//
//  ImageItem.swift
//  Unsplash
//
//  Created by Yasaman Farahani Saba on 10/7/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class ImageItem: Hashable {
    static func == (lhs: ImageItem, rhs: ImageItem) -> Bool {
        lhs === rhs
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: String
    let color: UIColor
    let desc: String
    var img: UIImage?
    let url: URL
    let height: CGFloat
    
    init(color: UIColor, desc: String, img: UIImage?, url: URL, height: CGFloat) {
        self.id = UUID().uuidString
        self.color = color
        self.desc = desc
        self.img = img
        self.url = url
        self.height = height
    }
}
