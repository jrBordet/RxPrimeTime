//
//  AppAction.swift
//  RxPrimeTime
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import Foundation

import Counter
import FavoritePrimes

enum AppAction {
    case counterView(CounterViewAction)
    case favoritePrimes(FavoritePrimesAction)
}

extension AppAction {
    var counterView: CounterViewAction? {
        get {
            guard case let .counterView(value) = self else { return nil }
            return value
        }
        set {
            guard case .counterView = self, let newValue = newValue else { return }
            self = .counterView(newValue)
        }
    }
    
    var favoritePrimes: FavoritePrimesAction? {
      get {
        guard case let .favoritePrimes(value) = self else { return nil }
        return value
      }
      set {
        guard case .favoritePrimes = self, let newValue = newValue else { return }
        self = .favoritePrimes(newValue)
      }
    }
}
