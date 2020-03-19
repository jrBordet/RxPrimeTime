//
//  FavoritePrimes+View.swift
//  FavoritePrimes
//
//  Created by Jean Raphael Bordet on 19/03/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import Foundation
import ComposableArchitecture
import RxSwift

public let favoritePrimesViewReducer: Reducer<FavoritePrimesViewState, FavoritePrimesViewAction, FavoritePrimesEnvironment> = combine(
    pullback(
        favoritePrimesReducer,
        value: \.favorites,
        action: \.favorites,
        environment: { $0 }
    )
)

public struct FavoritePrimesViewState: Equatable {
    public var favoritePrimes: [Int]
    public var isLoading: Bool
    public var alertNthPrime: NthPrimeAlert?
    
    public init(
        favoritePrimes: [Int] = [],
        isLoading: Bool = false,
        alertNthPrime: NthPrimeAlert? = nil
    ) {
        self.favoritePrimes = favoritePrimes
        self.isLoading = isLoading
        self.alertNthPrime = alertNthPrime
    }
    
    var favorites: FavoritePrimesState {
        get {
            (favorites: self.favoritePrimes, alertNthPrime: self.alertNthPrime, isLoading: self.isLoading)
        }
        set {
            (favorites: self.favoritePrimes, alertNthPrime: self.alertNthPrime, isLoading: self.isLoading) = newValue
        }
    }
}

public enum FavoritePrimesViewAction: Equatable {
  case favorites(FavoritePrimesAction)

  var favorites: FavoritePrimesAction? {
    get {
      guard case let .favorites(value) = self else { return nil }
      return value
    }
    set {
      guard case .favorites = self, let newValue = newValue else { return }
      self = .favorites(newValue)
    }
  }
}
