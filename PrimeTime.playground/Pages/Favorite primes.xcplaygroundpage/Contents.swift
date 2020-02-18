import UIKit
import PlaygroundSupport
import Counter
import ComposableArchitecture
import FavoritePrimes

let favoritePrimesScene = Scene<FavoritePrimesViewController>().render()

let state = [2, 3, 5]

favoritePrimesScene.store = Store(initialValue: state, reducer: favoritePrimesReducer(state:action:))

PlaygroundPage.current.liveView = favoritePrimesScene
