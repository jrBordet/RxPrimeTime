//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport
import Counter
import ComposableArchitecture
import FavoritePrimes

let counterScene = Scene<CounterViewController>().render()

let state = CounterViewState(
    count: 0,
    favoritePrimes: [2, 5, 7],
    isLoading: false,
    alertNthPrime: nil
)

counterScene.store = Store<CounterViewState, CounterViewAction>(initialValue: state, reducer: counterViewReducer)

let nvc = UINavigationController(rootViewController: counterScene)

PlaygroundPage.current.liveView = nvc

