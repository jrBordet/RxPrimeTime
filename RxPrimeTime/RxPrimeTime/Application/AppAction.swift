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

public enum AppAction: Equatable {
    case counterView(CounterViewAction)
    case favoritePrimesView(FavoritePrimesViewAction)
}

extension AppAction {
    public var counterView: CounterViewAction? {
        get {
            guard case let .counterView(value) = self else { return nil }
            return value
        }
        set {
            guard case .counterView = self, let newValue = newValue else { return }
            self = .counterView(newValue)
        }
    }
    
    public var favoritePrimesView: FavoritePrimesViewAction? {
        get {
            guard case let .favoritePrimesView(value) = self else { return nil }
            return value
        }
        set {
            guard case .favoritePrimesView = self, let newValue = newValue else { return }
            self = .favoritePrimesView(newValue)
        }
    }
}
