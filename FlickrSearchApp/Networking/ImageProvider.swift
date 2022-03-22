//
//  ImageProvider.swift
//  imageApi
//
//  Created by Amir Bakhshi on 2022-03-18.
//

import Foundation
import UIKit

class ImageProvider {
    static let instance = ImageProvider()
    
    private let cache = NSCache<NSString, UIImage>()
    
    /// Caches and returns a single photo.
    func fetchPhoto(photo: Item, completion: @escaping (Result<UIImage?, NetworkError>) -> Void) {
        
        let url = "https://live.staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
        
        if let image = cache.object(forKey: url as NSString) {
            //            print("Loading from cache ...")
            completion(.success(image))
            return
        }
        
        guard let urlString = URL(string: url) else { return }
        //        print("Fetching image ...")
        let task = URLSession.shared.dataTask(with: urlString, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(NetworkError.network(string: "Error making api call. \(error.debugDescription)")))
                return
            }
            
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else {
                    completion(.failure(NetworkError.network(string: "Failed to create image with the data. \(error.debugDescription)")))
                    return
                }
                // Caching
                self?.cache.setObject(image, forKey: url as NSString)
                completion(.success(image))
            }
        })
        task.resume()
    }
    
    /// Fetches user profile photo.
    func fetchProfilePhoto(for user: User, completion: @escaping(Result<UIImage?, NetworkError>) -> Void) {
        let url = "https://farm\(user.iconfarm).staticflickr.com/\(user.iconserver)/buddyicons/\(user.nsid).jpg"
        
        if let image = cache.object(forKey: url as NSString) {
            completion(.success(image))
            return
        }
        
        guard let urlString = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: urlString, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(NetworkError.network(string: "Error making api call. \(error.debugDescription)")))
                return
            }
            
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else {
                    completion(.failure(NetworkError.network(string: "Failed to create image with the data. \(error.debugDescription)")))
                    return
                }
                // Caching
                self?.cache.setObject(image, forKey: url as NSString)
                completion(.success(image))
            }
        })
        task.resume()
    }
    
    /// Fetches a photo from provided url.
    func fetchPhoto(from url: String, completion: @escaping(Result<UIImage?, NetworkError>) -> Void) {
        if let image = cache.object(forKey: url as NSString) {
            //            print("From cache ...")
            completion(.success(image))
            return
        }
        
        guard let urlString = URL(string: url) else { return }
        //        print("Fetching image ...")
        let task = URLSession.shared.dataTask(with: urlString, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(NetworkError.network(string: "Error making api call. \(error.debugDescription)")))
                return
            }
            
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else {
                    completion(.failure(NetworkError.network(string: "Failed to create image with the data. \(error.debugDescription)")))
                    return
                }
                // Caching
                self?.cache.setObject(image, forKey: url as NSString)
                completion(.success(image))
            }
        })
        task.resume()
    }
}
