//
//  PhotoService.swift
//  Unsplash
//
//  Created by Yasaman Farahani Saba on 10/4/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import CoreData
import UIKit

struct PhotoService: PhotoServiceType {
    
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchPhotos(at page: Int) -> [PhotoItem] {
        
        
        fetchPhotosFromAPI(at: page) { photos in
            
        }
    }
    
    private func fetchPhotosFromAPI(at page: Int, onComplete: ([PhotoItem]) -> ()) {
        if let url = URL(string: "https://api.unsplash.com/photos") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Client-ID OO0_7_FO-5OXrCbAGoYMc-Mf_D71fi1YseH_308qmPg", forHTTPHeaderField:"Authorization")
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                    onComplete([])
                    return
                }
                let decoder = JSONDecoder()
                decoder.userInfo[CodingUserInfoKey.context!] = self.context
                decoder.userInfo[CodingUserInfoKey.page!] = Int16(page)
                do {
                    let result = try decoder.decode([PhotoItem].self, from: data)
                    if result.count > 0 {
                        onComplete(result)
                    } else {
                        onComplete([])
                    }
                } catch {
                    onComplete([])
                }
            }
            task.resume()
        }
    }
    
    func fetchRandomPhoto() -> PhotoItem {
        <#code#>
    }
}
