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

public enum FavoritePrimesAction: Equatable {
    case deleteFavoritePrimes(Int)
    case saveButtonTapped
    case loadButtonTapped
    case loadedFavoritePrimes([Int])
}

public typealias FavoritePrimesState = [Int]

public func favoritePrimesReducer(state: inout FavoritePrimesState, action: FavoritePrimesAction) -> [Effect<FavoritePrimesAction>] {
    switch action {
    case let .deleteFavoritePrimes(index):
        state.remove(at: index)
        return []
    case .saveButtonTapped:
        return [
            CurrentFavoritePrimesEnvironment.fileClient.save("favorite-primes.json", try! JSONEncoder().encode(state)).map(absurd(_:))
        ]
    case let .loadedFavoritePrimes(favoritePrimes):
        state = favoritePrimes
        return []
    case .loadButtonTapped:
        return [
            CurrentFavoritePrimesEnvironment
                .fileClient
                .load("favorite-primes.json")
                .map(loadedFavoritePrimes(data:))
        ]
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


