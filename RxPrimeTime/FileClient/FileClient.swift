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

public struct FileClient {
    public var load: (String) -> Effect<Data?>
    public var save: (String, Data) -> Effect<Never>
    
    public init(
        load: @escaping(String) -> Effect<Data?>,
        save: @escaping(String, Data) -> Effect<Never>
    ) {
        self.load = load
        self.save = save
    }
}

extension FileClient {
    public static let live = FileClient(
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
            .fireAndForget {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let documentsUrl = URL(fileURLWithPath: documentsPath)
                let favoritePrimesUrl = documentsUrl.appendingPathComponent(fileName)
                try! data.write(to: favoritePrimesUrl)
            }
    }
    )
    
    public static let mock = FileClient(
        load: { _ in Effect<Data?>.sync {
            try! JSONEncoder().encode([2, 31])
            }
    },
        save: { _, _ in .fireAndForget {} }
    )
}
