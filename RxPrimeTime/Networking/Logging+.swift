//
//  Logging+.swift
//  MangaedenNetworking
//
//  Created by Jean Raphael Bordet on 28/11/2019.
//  Copyright © 2019 Bordet. All rights reserved.
//

import Foundation

func logError(with e: Error) {
    #if DEBUG
    print("❌ Error")
    dump(e)
    #endif
}

func logError(with e: Error, message: String) {
    #if DEBUG
    print(message)
    logError(with: e)
    #endif
}

func logMessage(with message: String, tag: String){
    #if DEBUG
    print("[\(tag)] \(message)")
    #endif
}
