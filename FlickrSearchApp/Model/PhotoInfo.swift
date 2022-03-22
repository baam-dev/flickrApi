//
//  Photo.swift
//  FlickrSearchApp
//
//  Created by Amir Bakhshi on 2022-03-19.
//

import Foundation
import UIKit

struct PhotoInfo: Codable {
    let photo: Photo
    let stat: String
}

struct Photo: Codable {
    let id:  String
    let secret: String
    let server: String
    let farm: Int
    let owner: User
    let views: String
}

struct User: Codable {
    let nsid: String
    let username: String
    let iconserver: String
    let iconfarm: Int
}

