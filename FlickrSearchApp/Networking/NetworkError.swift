//
//  NetworkError.swift
//  FlickrSearchApp
//
//  Created by Amir Bakhshi on 2022-03-21.
//

import Foundation

enum NetworkError: Error {
case network(string: String)
case unknown(string: String)
}
