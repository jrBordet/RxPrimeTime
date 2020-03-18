//
//  PrimeModal.swift
//  Counter
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import Foundation
import ComposableArchitecture

public typealias PrimeModalState = (count: Int, favoritePrimes: [Int])

public enum PrimeModalAction: Equatable {
    case saveFavoritePrimeTapped
    case removeFavoritePrimeTapped
}

public func primeModalReducer(
    state: inout PrimeModalState,
    action: PrimeModalAction,
    environment: Void
) -> [Effect<PrimeModalAction>] {
    switch action {
    case .saveFavoritePrimeTapped:
        guard isPrime(state.count) else {
            return []
        }
        
        state.favoritePrimes.append(state.count)
        return []
    case .removeFavoritePrimeTapped:
        guard 0...state.count - 1 ~= state.count else {
            return []
        }
        
        state.favoritePrimes.removeAll(where: { $0 == state.count })
        return []
    }
}

public func isPrime(_ p: Int) -> Bool {
  if p <= 1 { return false }
  if p <= 3 { return true }
  for i in 2...Int(sqrtf(Float(p))) {
    if p % i == 0 { return false }
  }
  return true
}
