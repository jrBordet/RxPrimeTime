import UIKit
import PlaygroundSupport
import Counter
import ComposableArchitecture
import FavoritePrimes
import FileClient

let favoritePrimesScene = Scene<FavoritePrimesViewController>().render()

let state = [2, 3, 5]

let favoritePrimeEnvironment = FavoritePrimesEnvironment(
    fileClient: .live,
    nthPrime: { _ in  return Effect.sync { 5 } }
)

let store = Store(
    initialValue: [2, 3, 5],
    reducer: favoritePrimesReducer,
    environment: favoritePrimeEnvironment
)

favoritePrimesScene.store = store

PlaygroundPage.current.liveView = favoritePrimesScene





