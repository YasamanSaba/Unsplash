//
//  UnsplashTests.swift
//  UnsplashTests
//
//  Created by Yasaman Farahani Saba on 9/28/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import XCTest
import CoreData
@testable import Unsplash

class UnsplashTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        context = InMemoryContextBuilder().persistentContainer.viewContext
    }

    override func tearDownWithError() throws {
        context = nil
    }
    
    func test_jsonFile_photo_count() {
        let fileURL = Bundle.main.url(forResource: "TestJson", withExtension: "json")
        XCTAssertNotNil(fileURL)
        var data: Data? = nil
        XCTAssertNoThrow(data = try Data(contentsOf: fileURL!))
        XCTAssertNotNil(data)
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.context!] = context
        decoder.userInfo[CodingUserInfoKey.page!] = Int16(integerLiteral: 0)
        var photos: [PhotoItem]? = nil
        XCTAssertNoThrow(photos = try decoder.decode([PhotoItem].self, from: data!))
        XCTAssertEqual(photos!.count, 10)
    }
    
}
