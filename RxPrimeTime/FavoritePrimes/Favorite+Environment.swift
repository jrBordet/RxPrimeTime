//
//  Favorite+Environment.swift
//  FavoritePrimes
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import Foundation
import RxSwift

struct FavoritePrimesEnvironment {
    var fileClient: FileClient
}

extension FavoritePrimesEnvironment {
    static let live = FavoritePrimesEnvironment(fileClient: .live)
}

#if DEBUG
extension FavoritePrimesEnvironment {
    static let mock = FavoritePrimesEnvironment(
        fileClient: FileClient(
            load: { path in
                .create { observer in
                    
                    observer.onNext(try! JSONEncoder().encode([2, 31])) // Array(1...100)
                    observer.onCompleted()
                    
                    return Disposables.create()
                }
        }, save: { path, data in
            .create { observer in
                
                observer.onCompleted()
                
                return Disposables.create()
            }
        })
    )
}
#endif

var CurrentFavoritePrimesEnvironment = FavoritePrimesEnvironment.live
