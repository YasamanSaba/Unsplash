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
    
    var delegate: PhotoServiceTypeDelegate?
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchPhotos(at page: Int) {
        let page = Int16(page)
        
        fetchPhotosFromAPI(at: page) { photos in
            if photos.count > 0 {
                DispatchQueue.main.async {
                    self.delegate?.fetched(photos: photos)
                }
            } else {
                let request: NSFetchRequest<PhotoItem> = PhotoItem.fetchRequest()
                request.predicate = NSPredicate(format: "%K == %i", #keyPath(PhotoItem.page), page)
                do {
                    let result = try self.context.fetch(request)
                    DispatchQueue.main.async {
                        self.delegate?.fetched(photos: result)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.delegate?.fetched(photos: [])
                    }
                }
            }
        }
    }
    private func clearPhotos(in page: Int16) {
        let request: NSFetchRequest<PhotoItem> = PhotoItem.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %d", #keyPath(PhotoItem.page), Int32(page))
        do {
            if let result = try self.context.fetch(request).first {
                self.context.delete(result)
                try self.context.save()
            }
        } catch {
            return
        }
    }
    
    private func fetchPhotosFromAPI(at page: Int16, onComplete: @escaping ([PhotoItem]) -> ()) {
        if let url = URL(string: "https://api.unsplash.com/photos?page=\(page)") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Client-ID OO0_7_FO-5OXrCbAGoYMc-Mf_D71fi1YseH_308qmPg", forHTTPHeaderField:"Authorization")
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                    onComplete([])
                    return
                }
                self.clearPhotos(in: page)
                let decoder = JSONDecoder()
                decoder.userInfo[CodingUserInfoKey.context!] = self.context
                decoder.userInfo[CodingUserInfoKey.page!] = page
                do {
                    let result = try decoder.decode([PhotoItem].self, from: data)
                    if result.count > 0 {
                        onComplete(result)
                        try self.context.save()
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
    func fetchImage(by url: URL, onComplete: @escaping (Data?) -> ()) {
        let request: NSFetchRequest<ImageCache> = ImageCache.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(ImageCache.url), url.absoluteString)
        do {
            let result = try context.fetch(request)
            if result.count == 1 {
                onComplete(result.first!.image!)
            } else {
                fetchImageFromAPI(by: url, onComplete: onComplete)
            }
        } catch {
            onComplete(nil)
        }
        
    }
    private func fetchImageFromAPI(by url: URL, onComplete: @escaping (Data?) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode), error == nil else {
                onComplete(nil)
                return
            }
            do {
                let image = ImageCache(context: context)
                image.url = url.absoluteString
                image.image = data
                try context.save()
                onComplete(data)
            } catch {
                onComplete(nil)
            }
        }.resume()
    }
    
    func fetchRandomPhoto(width: Int, onComplete: @escaping (Data?, String?) -> ()) {
        if let url = URL(string: "https://api.unsplash.com/photos/random/?client_id=OO0_7_FO-5OXrCbAGoYMc-Mf_D71fi1YseH_308qmPg&orientation=landscape") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode), error == nil else {
                    onComplete(nil, nil)
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let photo = try decoder.decode(RandomPhoto.self, from: data)
                    let url = URL(string: photo.rawUrl.absoluteString + "&w=\(width)")!
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let data = data, let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode), error == nil else {
                            onComplete(nil, nil)
                            return
                        }
                        onComplete(data, photo.color)
                    }.resume()
                } catch {
                    onComplete(nil, nil)
                }
            }.resume()
        }
    }
}
