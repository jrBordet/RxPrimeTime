//
//  CounterView.swift
//  Counter
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import Foundation
import ComposableArchitecture

import FileClient

public let counterViewReducer: Reducer<CounterFeatureState, CounterFeatureAction, CounterEnvironment> = combine(
    pullback(
        counterReducer,
        value: \CounterFeatureState.counter,
        action: \CounterFeatureAction.counter,
        environment: { $0 }
    ),
    pullback(
        primeModalReducer,
        value: \CounterFeatureState.primeModal,
        action: \CounterFeatureAction.primeModal,
        environment: { _ in () }
    )
)

public struct CounterFeatureState: Equatable {
    public var count: Int
    public var favoritePrimes: [Int]
    public var isLoading: Bool
    public var alertNthPrime: PrimeAlert?
    
    public init(
        count: Int = 0,
        favoritePrimes: [Int] = [],
        isLoading: Bool = false,
        alertNthPrime: PrimeAlert? = nil
    ) {
        self.count = count
        self.favoritePrimes = favoritePrimes
        self.isLoading = isLoading
        self.alertNthPrime = alertNthPrime
    }
    
    var counter: CounterState {
        get {
            (count: self.count, isLoading: self.isLoading, alertNthPrime: self.alertNthPrime)
        }
        set {
            (count: self.count, isLoading: self.isLoading, alertNthPrime: self.alertNthPrime) = newValue
        }
    }
    
    var primeModal: PrimeModalState {
      get { (self.count, self.favoritePrimes) }
      set { (self.count, self.favoritePrimes) = newValue }
    }
}

public enum CounterFeatureAction: Equatable {
  case counter(CounterAction)
  case primeModal(PrimeModalAction)

  var counter: CounterAction? {
    get {
      guard case let .counter(value) = self else { return nil }
      return value
    }
    set {
      guard case .counter = self, let newValue = newValue else { return }
      self = .counter(newValue)
    }
  }

  var primeModal: PrimeModalAction? {
    get {
      guard case let .primeModal(value) = self else { return nil }
      return value
    }
    set {
      guard case .primeModal = self, let newValue = newValue else { return }
      self = .primeModal(newValue)
    }
  }
}
