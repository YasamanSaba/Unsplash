//
//  PhotoItem+CoreDataClass.swift
//  Unsplash
//
//  Created by Yasaman Farahani Saba on 10/4/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//
//

import Foundation
import CoreData

enum PhotoItemError: Error {
    case decodeError
}

@objc(PhotoItem)
public class PhotoItem: NSManagedObject, Codable {
    private enum PhotoKeys: String, CodingKey {
        case id
        case width
        case height
        case color
        case urls
        case desc = "description"
    }
    
    private enum InnerKey: String, CodingKey {
        case raw
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext, let pageRequest = decoder.userInfo[CodingUserInfoKey.page!] as? Int16 else {
            throw PhotoItemError.decodeError
        }
        let container = try decoder.container(keyedBy: PhotoKeys.self)
        let subContainer = try container.nestedContainer(keyedBy: InnerKey.self, forKey: .urls)
        
        guard let entity = NSEntityDescription.entity(forEntityName: "PhotoItem", in: context) else { throw PhotoItemError.decodeError }
        self.init(entity: entity, insertInto: context)
        
        id = try container.decode(String.self, forKey: .id)
        width = try container.decode(Int32.self, forKey: .width)
        height = try container.decode(Int32.self, forKey: .height)
        color = try container.decode(String.self, forKey: .color)
        desc = try container.decode(String?.self, forKey: .desc)
        page = pageRequest
        let path = try subContainer.decode(String.self, forKey: .raw)
        rawURL = URL(string: path)
    }
}


