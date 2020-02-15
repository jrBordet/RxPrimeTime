//
//  Counter+Environment.swift
//  Counter
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import Foundation
import ComposableArchitecture
import RxSwift
import RxCocoa
import Networking

struct CounterEnvironment {
    var nthPrime: (Int) -> Effect<Int?>
}

extension CounterEnvironment {
    static let live = CounterEnvironment { n in
        return nthPrimeRequest(with: n)
    }
}

extension CounterEnvironment {
    static let mock = CounterEnvironment { n in
        return Effect.sync { 3 }
    }
}

var CurrentCounterEnvironment: CounterEnvironment = .live

private func nthPrimeRequest(with n: Int) -> Effect<Int?> {
    .create { observer -> Disposable in
        _ = performAPI(request: WolframAlphaRequest(query: "prime \(n)"), retry: nil, completion: { result in
            switch result {
            case .failure(_):
                break
            case let .success(content):
                let result =
                    content
                        .queryresult
                        .pods
                        .first(where: { $0.primary == .some(true) })?
                        .subpods
                        .first?
                        .plaintext
                
                observer.onNext(Int(result ?? "0"))
                observer.onCompleted()
            }
        })
        
        return Disposables.create()
    }
}
