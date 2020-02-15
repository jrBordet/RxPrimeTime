//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport
import Counter
import ComposableArchitecture
import FavoritePrimes

enum PrimeTimeScene {
    case counter, primemodal, favoritePrimes
}

let currentScene = PrimeTimeScene.counter

switch currentScene {
case .counter:
    let counterScene = Scene<CounterViewController>().render()

    counterScene.store = Store<CounterViewState, CounterViewAction>(initialValue: CounterViewState(count: 0,
                                                                                                   favoritePrimes: [2, 5, 7],
                                                                                                   isLoading: false,
                                                                                                   alertNthPrime: nil),
                                                                    reducer: counterViewReducer)
    
    let nvc = UINavigationController(rootViewController: counterScene)
    
    PlaygroundPage.current.liveView = nvc

    break
case .primemodal:
    let primeModalScene = Scene<PrimeModalViewController>().render()

    primeModalScene.store = Store<PrimeModalState, PrimeModalAction>(initialValue: (count: 2, favoritePrimes: [2, 5, 7]), reducer: primeModalReducer(state:action:))
    
    PlaygroundPage.current.liveView = primeModalScene

    break
case .favoritePrimes:
    let favoritePrimesScene = Scene<FavoritePrimesViewController>().render()

    favoritePrimesScene.store = Store(initialValue: [2, 3, 5], reducer: favoritePrimesReducer(state:action:))
    
    PlaygroundPage.current.liveView = favoritePrimesScene

    break
}

// Present the view controller in the Live View window
