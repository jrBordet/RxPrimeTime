//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport
import Counter
import ComposableArchitecture
import FavoritePrimes

let primeModalScene = Scene<PrimeModalViewController>().render()

primeModalScene.store = Store<PrimeModalState, PrimeModalAction>(initialValue: (count: 2, favoritePrimes: [2, 5, 7]), reducer: primeModalReducer(state:action:))

let counterScene = Scene<CounterViewController>().render()

counterScene.store = Store<CounterViewState, CounterViewAction>(initialValue: CounterViewState(count: 0,
                                                                                               favoritePrimes: [2, 5, 7],
                                                                                               isLoading: false,
                                                                                               alertNthPrime: nil),
                                                                reducer: counterViewReducer)

let favoritePrimesScene = Scene<FavoritePrimesViewController>().render()

favoritePrimesScene.store = Store(initialValue: [2, 3, 5], reducer: favoritePrimesReducer(state:action:))

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = favoritePrimesScene
