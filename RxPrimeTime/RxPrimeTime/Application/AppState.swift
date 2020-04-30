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
    var isLoading: Bool
    var activityFeed: [Activity] = []
    var alertNthPrime: PrimeAlert? = nil
    
    struct Activity: CustomDebugStringConvertible {
        var debugDescription: String {
            switch type {
            case let .addedFavoritePrime(value):
                return "\(self.timestamp.debugDescription) added \(value)"
            case let .removedFavoritePrime(value):
                return "\(self.timestamp.debugDescription) removed \(value)"
            }
        }
        
        let timestamp: Date
        let type: ActivityType
        
        enum ActivityType {
            case addedFavoritePrime(Int)
            case removedFavoritePrime(Int)
        }
    }
}

extension AppState: Equatable {
    static func == (lhs: AppState, rhs: AppState) -> Bool {
        lhs.count == rhs.count
            && lhs.isLoading == rhs.isLoading
    }
}

extension AppState {
    var counterView: CounterFeatureState {
        get {
            CounterFeatureState(
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
