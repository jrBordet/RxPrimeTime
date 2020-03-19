import UIKit
import PlaygroundSupport
import Counter
import ComposableArchitecture
import FavoritePrimes
import FileClient

let favoritePrimesScene = Scene<FavoritePrimesViewController>().render()

let favoritePrimeEnvironment = FavoritePrimesEnvironment(
    fileClient: .mock,
    nthPrime: { _ in  return Effect.sync { 5 } }
)

let store = Store(
    initialValue: FavoritePrimesViewState(
        favoritePrimes: [2, 3, 5, 7],
        isLoading: false,
        alertNthPrime: nil
    ),
    reducer: favoritePrimesViewReducer,
    environment: favoritePrimeEnvironment
)

favoritePrimesScene.store = store

PlaygroundPage.current.liveView = favoritePrimesScene





