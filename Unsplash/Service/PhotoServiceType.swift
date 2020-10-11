//
//  PhotoServiceType.swift
//  Unsplash
//
//  Created by Yasaman Farahani Saba on 10/4/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation

enum PhotoServiceError: Error {
    case createTaskError
    case fetchRandomError
}


protocol PhotoServiceType {
    var delegate: PhotoServiceTypeDelegate? {get set}
    func fetchPhotos(at page: Int)
    func fetchRandomPhoto(width: Int, onComplete: @escaping (Data?, String?) -> ())
    func fetchImage(by url: URL, onComplete: @escaping (Data?) -> ())
}

protocol PhotoServiceTypeDelegate {
    func fetched(photos: [PhotoItem])
}
