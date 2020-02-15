//
//  Counter.swift
//  Counter
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Networking
import RxSwift

public enum CounterAction: Equatable {
    case decrTapped
    case incrTapped
    case nthPrimeButtonTapped
    case nthPrimeResponse(Int?)
    case alertDismissButtonTapped
}

public typealias CounterState = (count: Int, isLoading: Bool, alertNthPrime: PrimeAlert?)

public let counterViewReducer = combine(
    pullback(counterReducer, value: \CounterViewState.counter, action: \CounterViewAction.counter),
    pullback(primeModalReducer, value: \.primeModal, action: \.primeModal)
)

public struct PrimeAlert: Equatable, Identifiable {
  let prime: Int
  public var id: Int { self.prime }
}

public func counterReducer(state: inout CounterState, action: CounterAction) -> [Effect<CounterAction>] {
    switch action {
    case .decrTapped:
        state.count -= 1
        return []
    case .incrTapped:
        state.count += 1
        return []
    case .nthPrimeButtonTapped:
        state.isLoading = true
        return [
            CurrentCounterEnvironment
                .nthPrime(state.count)
                .map(CounterAction.nthPrimeResponse)
        ]
    case let .nthPrimeResponse(prime):
        state.isLoading = false
        state.alertNthPrime = prime.map(PrimeAlert.init(prime:))
        return []
    case .alertDismissButtonTapped:
        state.alertNthPrime = nil
        return []
    }
}

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

public struct CounterViewState: Equatable {
    public var count: Int
    public var favoritePrimes: [Int]
    public var isLoading: Bool
    public var alertNthPrime: PrimeAlert?
    
    public init(
        count: Int = 0,
        favoritePrimes: [Int] = [],
        isLoading: Bool = false,
        alertNthPrime: PrimeAlert? = nil
    ) {
        self.count = count
        self.favoritePrimes = favoritePrimes
        self.isLoading = isLoading
        self.alertNthPrime = alertNthPrime
    }
    
    var counter: CounterState {
        get { (self.count, self.isLoading, self.alertNthPrime) }
        set { (self.count, self.isLoading, self.alertNthPrime) = newValue }
    }
    
    var primeModal: PrimeModalState {
      get { (self.count, self.favoritePrimes) }
      set { (self.count, self.favoritePrimes) = newValue }
    }
}

public enum CounterViewAction: Equatable {
  case counter(CounterAction)
  case primeModal(PrimeModalAction)

  var counter: CounterAction? {
    get {
      guard case let .counter(value) = self else { return nil }
      return value
    }
    set {
      guard case .counter = self, let newValue = newValue else { return }
      self = .counter(newValue)
    }
  }

  var primeModal: PrimeModalAction? {
    get {
      guard case let .primeModal(value) = self else { return nil }
      return value
    }
    set {
      guard case .primeModal = self, let newValue = newValue else { return }
      self = .primeModal(newValue)
    }
  }
}
