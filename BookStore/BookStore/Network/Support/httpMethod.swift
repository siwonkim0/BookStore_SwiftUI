//
//  httpMethod.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import Foundation

enum HttpMethod {
    case get
    case post
    case put
    case patch
    case delete
    
    var urlString: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .patch:
            return "PATCH"
        case .delete:
            return "DELETE"
        }
    }
}
