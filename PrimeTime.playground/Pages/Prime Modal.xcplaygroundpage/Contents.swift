//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport
import Counter
import ComposableArchitecture
import FavoritePrimes

let primeModalScene = Scene<PrimeModalViewController>().render()

let state = (count: 2, favoritePrimes: [2, 5, 7])

primeModalScene.store = Store<PrimeModalState, PrimeModalAction>(initialValue: state, reducer: primeModalReducer(state:action:))

PlaygroundPage.current.liveView = primeModalScene
