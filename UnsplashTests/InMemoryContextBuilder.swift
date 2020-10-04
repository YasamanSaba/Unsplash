//
//  InMemoryContext.swift
//  UnsplashTests
//
//  Created by Yasaman Farahani Saba on 10/4/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation
import CoreData

class InMemoryContextBuilder {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Unsplash")
        let storeDesc = NSPersistentStoreDescription()
        storeDesc.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [storeDesc]
        container.loadPersistentStores { desc, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}
