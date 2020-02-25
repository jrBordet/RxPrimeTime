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

public typealias CounterState = (count: Int, isLoading: Bool, alertNthPrime: PrimeAlert?)

public struct PrimeAlert: Equatable, Identifiable {
  let prime: Int
  public var id: Int { self.prime }
}

public enum CounterAction: Equatable {
    case decrTapped
    case incrTapped
    case nthPrimeButtonTapped
    case nthPrimeResponse(Int?)
    case alertDismissButtonTapped
}

public func counterReducer(
    state: inout CounterState,
    action: CounterAction,
    environment: CounterEnvironment
) -> [Effect<CounterAction>] {
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
            environment(state.count).map(CounterAction.nthPrimeResponse)
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


