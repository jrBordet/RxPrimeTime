//
//  AppReducer.swift
//  RxPrimeTime
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Counter
import FavoritePrimes
import FileClient

typealias AppEnvironment = (
    fileClient: FileClient,
    nthPrime: (Int) -> Effect<Int?>
)

let appEnvironment = AppEnvironment(
    fileClient: .live,
    nthPrime: Counter.nthPrimeRequest
)

let initialAppState = AppState(
    count: 0,
    favoritePrimes: [],
    isLoading: false
)

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = combine(
    pullback(
        counterViewReducer,
        value: \AppState.counterView,
        action: \AppAction.counterView,
        environment: { $0.nthPrime }
    ),
    pullback(
        favoritePrimesViewReducer,
        value: \AppState.favoritesView,
        action: \AppAction.favoritePrimesView,
        environment: { ($0.fileClient, $0.nthPrime) }
    )
)

var applicationStore: Store<AppState, AppAction> =
    Store(
        initialValue: initialAppState,
        reducer: with(
            appReducer,
            compose(
                logging,
                activityFeed
        )),
        environment: appEnvironment
)

func activityFeed(
    _ reducer: @escaping Reducer<AppState, AppAction, AppEnvironment>
) -> Reducer<AppState, AppAction, AppEnvironment> {
    return { state, action, environment in
        switch action {
        case .counterView(.primeModal(.saveFavoritePrimeTapped)):
            state.activityFeed.append(AppState.Activity(timestamp: Date(), type: .addedFavoritePrime(state.count)))
            break
            
        case .counterView(.primeModal(.removeFavoritePrimeTapped)):
            state.activityFeed.append(AppState.Activity(timestamp: Date(), type: .removedFavoritePrime(state.count)))
            break
            
        case .counterView(_):
            break
        default:
            break
//        case .favoritePrimes(.deleteFavoritePrimes(_)):
//            break
//        case .favoritePrimes(.saveButtonTapped):
//            break
//        case .favoritePrimes(.loadedFavoritePrimes(_)):
//            break
//        case .favoritePrimes(.loadButtonTapped):
//            break
//        case .favoritePrimes(.nthPrimeButtonTapped):
//            break
//        case .favoritePrimes(.nthPrimeResponse(_)):
//            break
        }
        
        return reducer(&state, action, environment)
    }
}
