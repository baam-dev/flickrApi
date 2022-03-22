//
//  APIResponse.swift
//  FlickrSearchApp
//
//  Created by Amir Bakhshi on 2022-03-18.
//

import Foundation
import UIKit

struct APIResponse: Codable {
    let stat: String
    let photos: Photos
}

struct Photos: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photo: [Item]
}

struct Item: Codable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
}

