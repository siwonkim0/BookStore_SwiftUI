//
//  BookDetailRequest.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/10/01.
//

import Foundation

struct BookDetailRequest: NetworkRequest {
    typealias ResponseType = BookDetailDTO
    
    var httpMethod: HttpMethod = .get
    var urlHost: String = BookStoreURLHost.detail.urlString
    var urlPath: String
    var httpHeader: [String: String]?
    var httpBody: Data?
}
