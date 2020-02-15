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

var currentViewController = UIViewController.init()

switch currentScene {
case .counter:
    let counterScene = Scene<CounterViewController>().render()

    let state = CounterViewState(
        count: 0,
        favoritePrimes: [2, 5, 7],
        isLoading: false,
        alertNthPrime: nil
    )
    
    counterScene.store = Store<CounterViewState, CounterViewAction>(initialValue: state, reducer: counterViewReducer)
    
    let nvc = UINavigationController(rootViewController: counterScene)
    
    currentViewController = nvc

    break
case .primemodal:
    let primeModalScene = Scene<PrimeModalViewController>().render()
    
    let state = (count: 2, favoritePrimes: [2, 5, 7])

    primeModalScene.store = Store<PrimeModalState, PrimeModalAction>(initialValue: state, reducer: primeModalReducer(state:action:))
    
    currentViewController = primeModalScene

    break
case .favoritePrimes:
    let favoritePrimesScene = Scene<FavoritePrimesViewController>().render()

    let state = [2, 3, 5]
    
    favoritePrimesScene.store = Store(initialValue: state, reducer: favoritePrimesReducer(state:action:))
    
    currentViewController = favoritePrimesScene

    break
}

PlaygroundPage.current.liveView = currentViewController
