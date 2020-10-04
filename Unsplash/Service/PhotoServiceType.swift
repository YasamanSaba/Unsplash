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
}


protocol PhotoServiceType {
    func fetchPhotos(at page: Int) -> [PhotoItem]
    func fetchRandomPhoto() -> PhotoItem
}
