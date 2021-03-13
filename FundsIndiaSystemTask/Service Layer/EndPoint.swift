//
//  EndPoint.swift
//  FundsIndiaSystemTask
//
//  Created by Pradeep's Macbook on 12/03/21.
//  Copyright © 2021 Motiv Ate Fitness. All rights reserved.
//

import UIKit

struct EndPoint {
    
    var path: String
    var queryItems: [URLQueryItem] = []
}

extension EndPoint {
    
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.github.com"
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            preconditionFailure("Invalid URL Components:\(urlComponents)")
        }
        return url
    }
    
}

extension EndPoint {
    
    static func getPublicRepos(with batchIndex: Int) -> Self {
        return EndPoint(path: "/repositories", queryItems: [.init(name: "since", value: "\(batchIndex)")])
    }
    
    static func getFollowers(by userName: String) -> Self {
        return .init(path: "/users/\(userName)/followers")
    }
    
    static func getFollowing(by userName: String) -> Self {
        return .init(path: "/users/\(userName)/following")
    }
    
    static func getUserLocation(by userName: String) -> Self {
         return .init(path: "/users/\(userName)")
    }
    
    static func getUserRepos(by userName: String) -> Self {
        return .init(path: "/users/\(userName)/repos")
    }
}
