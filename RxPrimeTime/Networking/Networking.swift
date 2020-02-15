//
//  Networking.swift
//  Networking
//
//  Created by Jean Raphael Bordet on 29/01/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import Foundation

public enum NetworkingEnv {
    case stage
    case prod
}

public class Networking {
    internal static var bundle: Bundle {
        return Bundle(for: Networking.self)
    }
    
    internal static let cache: URLCache = URLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: nil)
    internal static var session: URLSession = {
        var config = URLSessionConfiguration.default
        config.urlCache = cache
        return URLSession(configuration: config)
    }()
    
    public static var version = "1.0.0"
    internal static var maxRetry = 3
    internal static var env: NetworkingEnv = .stage
    
    public init () {
        
    }
}

extension NetworkingEnv {
    var baseUrl: String {
        switch self {
        case .stage, .prod:
            return "https://www.mangaeden.com"
        }
    }
    
    var imageBaseUrl: String {
        switch self {
        case .stage, .prod:
            return "https://cdn.mangaeden.com/mangasimg"
        }
    }
}
