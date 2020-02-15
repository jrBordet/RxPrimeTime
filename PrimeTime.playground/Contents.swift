//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport
import Counter
import ComposableArchitecture

let primeModalScene = Scene<PrimeModalViewController>().render()

primeModalScene.store = Store<PrimeModalState, PrimeModalAction>(initialValue: (count: 2, favoritePrimes: [2, 5, 7]), reducer: primeModalReducer(state:action:))

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = primeModalScene
//MyViewController()
