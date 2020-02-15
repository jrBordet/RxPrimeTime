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

var applicationStore: Store<AppState, AppAction> = Store(initialValue: AppState(count: 0, favoritePrimes: [],
                                                                     isLoading: false),
                                              reducer: with(
                                                appReducer,
                                                compose(
                                                    logging,
                                                    activityFeed
                                              )))

let appReducer = combine(
    pullback(counterViewReducer, value: \AppState.counterView, action: \AppAction.counterView),
    pullback(favoritePrimesReducer, value: \AppState.favoritePrimes, action: \AppAction.favoritePrimes)
)

func activityFeed(
  _ reducer: @escaping Reducer<AppState, AppAction>
) -> Reducer<AppState, AppAction> {
  return { state, action in
    switch action {
    case .counterView(.primeModal(.saveFavoritePrimeTapped)):
        state.activityFeed.append(AppState.Activity(timestamp: Date(), type: .addedFavoritePrime(state.count)))
        break
        
    case .counterView(.primeModal(.removeFavoritePrimeTapped)):
        state.activityFeed.append(AppState.Activity(timestamp: Date(), type: .removedFavoritePrime(state.count)))
        break
        
    case .counterView(_):
        break
    case .favoritePrimes(.deleteFavoritePrimes(_)):
        break
    case .favoritePrimes(.saveButtonTapped):
        break
    case .favoritePrimes(.loadedFavoritePrimes(_)):
        break
    case .favoritePrimes(.loadButtonTapped):
        break
    }

    return reducer(&state, action)
  }
}
