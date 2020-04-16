//
//  APIRequest.swift
//  Networking
//
//  Created by Jean Raphael Bordet on 28/11/2019.
//  Copyright © 2019 Bordet. All rights reserved.
//

import Foundation

public enum ApiResult<A> {
    case success(A)
    case failure(Error)
}

public typealias ResultCompletion<Value> = (ApiResult<Value>) -> Void

public protocol APIRequest {
    associatedtype Response: Decodable
    
    var endpoint: String { get }
    
    var request: URLRequest { get }
}

internal func decode<T: APIRequest>(request r: T, data: Data) -> ApiResult<T.Response> {
    do {
        let result = try JSONDecoder().decode(T.Response.self, from: data)
        return .success(result)
    } catch let error {
        #if DEBUG
        dump(String(data: data, encoding: .utf8))
        #endif
        
        logError(with: error, message: r.request.debugDescription)
        
        return .failure(error)
    }
}

public func performAPI<T: APIRequest>(request r: T, retry: Int? = 0, completion: @escaping ResultCompletion<T.Response>) -> URLSessionDataTask {
    let task = Networking.session.dataTask(with: r.request) { (data: Data?, response: URLResponse?, error: Error?) in
        guard let data = data else {
            .failure(APIError.empty) |> completion
            return
        }
        
        #if DEBUG
        dump(r.request)
        #endif
        
        guard let statusCode = HTTPStatusCodes.decode(from: response) else {
            logError(with: APIError.undefinedStatusCode, message: response.debugDescription)

            ApiResult.failure(APIError.undefinedStatusCode) |> completion
            return
        }
        
        switch statusCode {
        case .Ok:
            break
        case .Unauthorized:
            logMessage(with: "Unauthorized - 401", tag: "performAPI")

            guard let retry = retry, retry <= Networking.maxRetry else {
                .failure(APIError.code(statusCode, r.request)) |> completion
                return
            }
            
            // Retry the last request
            _ = performAPI(request: r,
                           retry: retry + 1,
                           completion: completion)
            return
        default:
            .failure(APIError.code(statusCode, r.request)) |> completion
            return
        }
        
        //logMessage(with: String(data: data, encoding: .utf8) ?? "", tag: "performAPI")
        
        decode(request: r, data: data) |> completion
    }
    
    task.resume()
    
    return task
}

enum APIError: Error {
    case code(HTTPStatusCodes, URLRequest)
    case undefinedStatusCode
    case empty
    case failedAccessToken(Error)
}
