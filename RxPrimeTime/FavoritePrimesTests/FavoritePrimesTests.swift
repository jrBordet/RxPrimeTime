//
//  FavoritePrimesTests.swift
//  FavoritePrimesTests
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import ComposableArchitecture
import FileClient
@testable import FavoritePrimes

class FavoritePrimesTests: XCTestCase {    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        //CurrentFavoritePrimesEnvironment = .mock
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDeleteAtIndex() {
        let state = FavoritePrimesViewState(
            favoritePrimes: [2, 3, 5, 7],
            isLoading: false,
            alertNthPrime: nil
        )
        
        let favoritePrimeEnvironment = FavoritePrimesEnvironment(
            fileClient: .mock,
            nthPrime: { _ in .sync { nil } }
        )
        
        assert(
            initialValue: state,
            reducer: favoritePrimesViewReducer,
            environment: favoritePrimeEnvironment,
            steps:
            Step(.send, .favorites(.deleteFavoritePrimes(0)), { $0.favoritePrimes = [3, 5, 7] }),
            Step(.send, .favorites(.deleteFavoritePrimes(2)), { $0.favoritePrimes = [3, 5] }),
            Step(.send, .favorites(.deleteFavoritePrimes(10)), { $0.favoritePrimes = [3, 5] }),
            Step(.send, .favorites(.deleteFavoritePrimes(-1)), { $0.favoritePrimes = [3, 5] })
        )
    }
    
    func testLoadButtonTapped() {
        let state: FavoritePrimesViewState = FavoritePrimesViewState()

        let test = FileClient(
            load: { _ in Effect<Data?>.sync {
                try! JSONEncoder().encode([2, 31])
                }
        },
            save: { _, _ in .fireAndForget {} }
        )

        let favoritePrimeEnvironment = FavoritePrimesEnvironment(
            fileClient: test,
            nthPrime: { _ in .sync { 5 } }
        )

        assert(
            initialValue: state,
            reducer: favoritePrimesViewReducer,
            environment: favoritePrimeEnvironment,
            steps:
            Step(.send, .favorites(.loadButtonTapped), { $0.favoritePrimes = []}),
            Step(.receive, .favorites(.loadedFavoritePrimes([2, 31])), { $0.favoritePrimes = [2, 31] })
        )
    }
    
    func testSaveButtonTapped() {
        let state = FavoritePrimesViewState()

        let favoritePrimeEnvironment = FavoritePrimesEnvironment(
            fileClient: .mock,
            nthPrime: { _ in  return .sync { 5 } }
        )

        assert(
            initialValue: state,
            reducer: favoritePrimesViewReducer,
            environment: favoritePrimeEnvironment,
            steps:
            Step(.sendSync, .favorites(.saveButtonTapped), { $0.favoritePrimes = [] })
        )
    }
    
    func testNthPrime() {
        let state = FavoritePrimesViewState(
            favoritePrimes: [2, 3, 5, 7],
            isLoading: false,
            alertNthPrime: nil
        )

        let favoritePrimeEnvironment = FavoritePrimesEnvironment(
            fileClient: .mock,
            nthPrime: { _ in  return .sync { 5 } }
        )

        assert(
            initialValue: state,
            reducer: favoritePrimesViewReducer,
            environment: favoritePrimeEnvironment,
            steps:
            Step(.send, .favorites(.nthPrimeButtonTapped(3)), {
                $0.favoritePrimes = [2, 3, 5, 7]
                $0.isLoading = true
                $0.alertNthPrime = nil
            }),
            Step(.receive, .favorites(.nthPrimeResponse(5)), {
                $0.isLoading = false
                $0.alertNthPrime = NthPrimeAlert(prime: 5)
            })
        )
    }

}
