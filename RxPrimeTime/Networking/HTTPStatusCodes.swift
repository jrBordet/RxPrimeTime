//
//  HTTPStatusCodes.swift
//  Networking
//
//  Created by Jean Raphael Bordet on 28/11/2019.
//  Copyright © 2019 Bordet. All rights reserved.
//

import Foundation

enum HTTPStatusCodes: Int {
    // 200 Success
    case Ok = 200
    case Created = 201 // incomplete login
    
    // 300
    case NotModified = 300
    
    // 400 Client Error
    case BadRequest = 400
    case Unauthorized = 401
    case Forbidden = 403
    case NotFound = 404
    case Duplicated = 409
    case ValdiationFail = 422
    
    // 500 Server Error
    case InternalServerError = 500
    case ServiceUnavailable = 503
}

extension HTTPStatusCodes {
    public static func decode(from response: URLResponse?) -> HTTPStatusCodes? {
        guard let HTTPURLResponse = (response as? HTTPURLResponse),
            let statusCode = HTTPStatusCodes(rawValue: HTTPURLResponse.statusCode) else {
                return nil
        }
        
        return statusCode
    }
}
