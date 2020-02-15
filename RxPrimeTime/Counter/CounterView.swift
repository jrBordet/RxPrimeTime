//
//  CounterView.swift
//  Counter
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import Foundation
import ComposableArchitecture

public let counterViewReducer = combine(
    pullback(counterReducer, value: \CounterViewState.counter, action: \CounterViewAction.counter),
    pullback(primeModalReducer, value: \CounterViewState.primeModal, action: \CounterViewAction.primeModal)
)

public struct CounterViewState: Equatable {
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
        get { (self.count, self.isLoading, self.alertNthPrime) }
        set { (self.count, self.isLoading, self.alertNthPrime) = newValue }
    }
    
    var primeModal: PrimeModalState {
      get { (self.count, self.favoritePrimes) }
      set { (self.count, self.favoritePrimes) = newValue }
    }
}

public enum CounterViewAction: Equatable {
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
