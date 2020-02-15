//
//  AppState.swift
//  RxPrimeTime
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import Foundation

import Counter
import FavoritePrimes

struct AppState {
    var count: Int
    var favoritePrimes: FavoritePrimesState
    var activityFeed: [Activity] = []
    var isLoading: Bool
    var alertNthPrime: PrimeAlert? = nil
    
    struct Activity {
      let timestamp: Date
      let type: ActivityType

      enum ActivityType {
        case addedFavoritePrime(Int)
        case removedFavoritePrime(Int)
      }
    }
}

extension AppState {
    var counterView: CounterViewState {
        get {
            CounterViewState(
                count: self.count,
                favoritePrimes: self.favoritePrimes,
                isLoading: self.isLoading,
                alertNthPrime: self.alertNthPrime
            )
        }
        set {
            self.count = newValue.count
            self.favoritePrimes = newValue.favoritePrimes
            self.isLoading = newValue.isLoading
            self.alertNthPrime = newValue.alertNthPrime
        }
    }
}
