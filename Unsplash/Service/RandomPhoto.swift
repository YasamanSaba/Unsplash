//
//  RandomPhoto.swift
//  Unsplash
//
//  Created by Yasaman Farahani Saba on 10/10/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

struct RandomPhoto: Codable {
    let color: String
    let rawUrl: URL
    
    enum RandomPhotoCodingKeys: CodingKey {
        case color
        case urls
    }
    
    enum UrlsCodingKey: CodingKey {
        case raw
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RandomPhotoCodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: UrlsCodingKey.self, forKey: .urls)
        color = try container.decode(String.self, forKey: .color)
        rawUrl = try nestedContainer.decode(URL.self, forKey: .raw)
    }
}
