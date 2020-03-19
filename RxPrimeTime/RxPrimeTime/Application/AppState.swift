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

public struct AppState {
    var count: Int
    var favoritePrimes: [Int]
    var isLoading: Bool
    var activityFeed: [Activity] = []
    var alertNthPrime: PrimeAlert? = nil
    var favoritesAlertNthPrime: NthPrimeAlert? = nil
    
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
    public static func == (lhs: AppState, rhs: AppState) -> Bool {
        lhs.count == rhs.count && lhs.isLoading == rhs.isLoading
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
    
    var favoritesView: FavoritePrimesViewState {
        get {
            FavoritePrimesViewState(
                favoritePrimes: self.favoritePrimes,
                isLoading: self.isLoading,
                alertNthPrime: self.favoritesAlertNthPrime
            )
        }
        
        set {
            self.favoritePrimes = newValue.favoritePrimes
            self.isLoading = newValue.isLoading
            self.favoritesAlertNthPrime = newValue.alertNthPrime
        }
    }
}
