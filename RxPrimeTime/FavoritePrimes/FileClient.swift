//
//  FileClient.swift
//  FavoritePrimes
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import Foundation
import ComposableArchitecture
import RxSwift

struct FileClient {
    var load: (String) -> Effect<Data?>
    var save: (String, Data) -> Effect<Never>
}

extension FileClient {
    static let live = FileClient(
        load: { fileName -> Effect<Data?> in
            .create { observer in
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let documentsUrl = URL(fileURLWithPath: documentsPath)
                let favoritePrimesUrl = documentsUrl.appendingPathComponent(fileName)
                
                guard let data = try? Data(contentsOf: favoritePrimesUrl) else {
                    return Disposables.create()
                }
                
                observer.onNext(data)
                
                return Disposables.create()
            }
    },
        save: { fileName, data in
            return .fireAndForget {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let documentsUrl = URL(fileURLWithPath: documentsPath)
                let favoritePrimesUrl = documentsUrl.appendingPathComponent(fileName)
                try! data.write(to: favoritePrimesUrl)
            }
    }
    )
}
