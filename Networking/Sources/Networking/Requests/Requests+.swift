//
//  Requests+.swift
//  Networking
//
//  Created by Jean Raphael Bordet on 29/01/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import Foundation

private let wolframAlphaApiKey = "6H69Q3-828TKQJ4EP"

public struct WolframAlphaResult: Decodable {
    public let queryresult: QueryResult
    
    public struct QueryResult: Decodable {
        public let pods: [Pod]
        
        public struct Pod: Decodable {
            public let primary: Bool?
            public let subpods: [SubPod]
            
            public struct SubPod: Decodable {
                public let plaintext: String
            }
        }
    }
}

/// https://api.wolframalpha.com/v2/query?input=prime%204&format=plaintext&output=JSON&appid=6H69Q3-828TKQJ4EP

public struct WolframAlphaRequest: APIRequest, CustomDebugStringConvertible {
    public var debugDescription: String {
        return request.debugDescription
    }
    
    public typealias Response = WolframAlphaResult
    
    public var endpoint: String = "/v2/query"
    
    let query: String
    
    public var request: URLRequest {
        var components = URLComponents(string: "https://api.wolframalpha.com" + endpoint)!
                
        components.queryItems = [
            URLQueryItem(name: "input", value: self.query),
            URLQueryItem(name: "format", value: "plaintext"),
            URLQueryItem(name: "output", value: "JSON"),
            URLQueryItem(name: "appid", value: wolframAlphaApiKey),
        ]
        
        var request = URLRequest(url: components.url(relativeTo: nil)!)
        
        request.httpMethod = "GET"
        
        return request
    }
    
    public init (query: String) {
        self.query = query
    }
}

