//
//  FavoritePrimes.swift
//  FavoritePrimes
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import Foundation
import ComposableArchitecture
import RxSwift
import FileClient

public typealias FavoritePrimesState = [Int]

public enum FavoritePrimesAction: Equatable {
    case deleteFavoritePrimes(Int)
    
    case saveButtonTapped
    
    case loadButtonTapped
    case loadedFavoritePrimes([Int])
    
    case nthPrimeButtonTapped
    case nthPrimeResponse(Int?)
}

public typealias FavoritePrimesEnvironment = (
  fileClient: FileClient,
  nthPrime: (Int) -> Effect<Int?>
)

public func favoritePrimesReducer(
    state: inout FavoritePrimesState,
    action: FavoritePrimesAction,
    environment: FavoritePrimesEnvironment
) -> [Effect<FavoritePrimesAction>] {
    switch action {
    case let .deleteFavoritePrimes(index):
        guard 0...state.count - 1 ~= index else {
            return []
        }
        
        state.remove(at: index)
        return []
    case .saveButtonTapped:
        return [
            environment
                .fileClient
                .save("favorite-primes.json", try! JSONEncoder()
                    .encode(state))
                .map(absurd(_:))
        ]
    case let .loadedFavoritePrimes(favoritePrimes):
        state = favoritePrimes
        return []
    case .loadButtonTapped:
        return [
            environment
                .fileClient
                .load("favorite-primes.json")
                .map(loadedFavoritePrimes(data:))
        ]
    case .nthPrimeButtonTapped:
        return [
            environment
                .nthPrime(state.first!).map(FavoritePrimesAction.nthPrimeResponse)
        ]
    case let .nthPrimeResponse(prime):
        //state.alertNthPrime = prime.map(PrimeAlert.init(prime:))
        return []
    }
}

private func loadedFavoritePrimes(data: Data?) -> FavoritePrimesAction {
    do {
        guard
            let data = data,
            let favoritePrimes = try? JSONDecoder().decode([Int].self, from: data) else {
                return .loadedFavoritePrimes([])
        }
        
        return .loadedFavoritePrimes(favoritePrimes)
    }
}

func absurd<A>(_ never: Never) -> A {}


