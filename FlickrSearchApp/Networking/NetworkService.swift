//
//  NetworkService.swift
//  FlickrSearchApp
//
//  Created by Amir Bakhshi on 2022-03-18.
//

import Foundation
import UIKit

class NetworkService {
    
    static let instance = NetworkService()
    let apiKey = "cd3aab4cd4bd4d372a9e0d14f33e7dbf"
    
    /// Returns the first response from the api. APIResponse contains the actual information about images.
    func sendReguest(for keyword: String, completion: @escaping (Result<[PhotoModel]?, NetworkError>) -> Void) {
        let method = "flickr.photos.search"
        let url = "https://api.flickr.com/services/rest/?method=\(method)&api_key=\(apiKey)&text=\(keyword)&content_type=1&per_page=70&format=json&nojsoncallback=1"
        print(url)
        guard let urlStr = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: urlStr) { [weak self] data, _, error in
            
            guard let data = data, error == nil else {
                completion(.failure(NetworkError.network(string: "Error making api call. \(error.debugDescription)")))
                return
            }
            do {
                let decoder = JSONDecoder()
                let jsonResult = try decoder.decode(APIResponse.self, from: data)
                self?.fetchArts(from: jsonResult, completion: { result in
                    switch result {
                    case .success(let arts):
                        completion(.success(arts))
                    case .failure(let error):
                        print(NetworkError.network(string: "Failed fetching art. \(error)"))
                    }
                })
                
            } catch {
                completion(.failure(NetworkError.network(string: "Failed parsing data from the api call. \(error)")))
            }
        }
        task.resume()
    }
    
    /// Fetches first batch of arts that will be pupulated in main page.
    func fetchArts(from response: APIResponse, completion: @escaping(Result<[PhotoModel]?, NetworkError>) -> Void) {
        var arts = [PhotoModel]()
        let items = response.photos.photo
        
        for item in items {
            ImageProvider.instance.fetchPhoto(photo: item, completion: { [weak self] artResult in
                switch artResult {
                case .success(let image):
                    self?.getPhotoInfo(for: item, completion: { infoResult in
                        switch infoResult {
                        case .success(let info):
                            guard let owner = info?.photo.owner else { return }
                            
                            ImageProvider.instance.fetchProfilePhoto(for: owner, completion: { profilePicResult in
                                switch profilePicResult {
                                case .success(let profilePhoto):
                                    
                                    let urlForLArgeImage = self?.createUrlFor(photo: item)
                                    
                                    guard let image = image,
                                          let url = urlForLArgeImage,
                                          let username = info?.photo.owner.username,
                                          let views = info?.photo.views,
                                          let profilePhoto = profilePhoto else { return }
                                    
                                    let newArt = PhotoModel(image: image,
                                                     imageUrl: url,
                                                     profileImage: profilePhoto,
                                                     username: username,
                                                     views: views)
                                    arts.append(newArt)
                                    
                                case .failure(let error):
                                    completion(.failure(NetworkError.network(string: "Failed fetching profile photo. \(error)")))
                                }
                            })
                        case .failure(let error):
                            completion(.failure(NetworkError.network(string: "Failed getting photo information. \(error)")))
                        }
                    })
                case .failure(let error):
                    completion(.failure(NetworkError.network(string: "Failed fetching photo. \(error)")))
                }
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            completion(.success(arts))
        }
    }
    
    /// Fetches information of a certain photo.
    func getPhotoInfo(for item: Item, completion: @escaping(Result<PhotoInfo?, NetworkError>) -> Void) {
        let method = "flickr.photos.getInfo"
        let url = "https://api.flickr.com/services/rest/?method=\(method)&api_key=\(apiKey)&photo_id=\(item.id)&format=json&nojsoncallback=1"
        
        guard let urlStr = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: urlStr) { data, _, error in
            
            guard let data = data, error == nil else {
                completion(.failure(NetworkError.network(string: "Error making api call. \(error.debugDescription)")))
                return
            }
            do {
                let decoder = JSONDecoder()
                let jsonResult = try decoder.decode(PhotoInfo.self, from: data)
                completion(.success(jsonResult))
                
            } catch {
                completion(.failure(NetworkError.network(string: "Failed parsing data from the api call. \(error)")))
            }
        }
        task.resume()
    }
    
    /// Creates url string, in order to download the image in bigger size.
    func createUrlFor(photo: Item) -> String? {
        let url = "https://live.staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_b.jpg"
        return url
    }
}
