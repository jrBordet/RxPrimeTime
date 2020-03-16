//
//  CounterTests.swift
//  CounterTests
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import XCTest
@testable import Counter
import ComposableArchitecture

class CounterTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        //CurrentCounterEnvironment = .mock
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Counter
    
    func testErgonomicIncrDecrButtonTapped() {
        assert(
            initialValue: CounterViewState(count: 2,
                                           favoritePrimes: [2, 3],
                                           isLoading: false,
                                           alertNthPrime: nil),
            reducer: counterViewReducer,
            environment: { _  in Effect.sync { 3 } },
            steps:
            Step(.send, .counter(.incrTapped)) { $0.count = 3 },
            Step(.send, .counter(.decrTapped), { $0.count = 2 }
            )
        )
    }
    
    func testErgonomicNthPrimeButtonHappyFlow() {
        let nthPrime: (Int) -> Effect<Int?> = { _ in Effect.sync { 17 } }
        
        assert(
            initialValue: CounterViewState(
                isLoading: false,
                alertNthPrime: nil
            ),
            reducer: counterViewReducer,
            environment: nthPrime,
            steps:
            Step(.send, .counter(.nthPrimeButtonTapped)) {
                $0.isLoading = true
            },
            Step(.receive, .counter(.nthPrimeResponse(17))) {
                $0.alertNthPrime = PrimeAlert(prime: 17)
                $0.isLoading = false
            },
            Step(.send, .counter(.alertDismissButtonTapped)) {
                $0.alertNthPrime = nil
            }
        )
    }
    
    func testErgonomicNthPrimeButtonUnhappyFlow() {
        let nthPrime: (Int) -> Effect<Int?> = { _ in Effect.sync { nil } }
        
        assert(
            initialValue: CounterViewState(
                isLoading: false,
                alertNthPrime: nil
            ),
            reducer: counterViewReducer,
            environment: nthPrime,
            steps:
            Step(.send, .counter(.nthPrimeButtonTapped)) {
                $0.isLoading = true
            },
            Step(.receive, .counter(.nthPrimeResponse(nil))) {
                $0.isLoading = false
                $0.alertNthPrime = nil
            }
        )
    }
    
    // MARK: Prime modal
    
    func testSaveFavoritePrimesTapped() {
        var state = (count: 2, favoritePrimes: [3, 5])
        
        let effects = primeModalReducer(state: &state, action: .saveFavoritePrimeTapped, environment: ())
        
        // If prime modal state ever changes, this will fail to compile,
        // forcing us to make changes to our test.
        let (count, favoritePrimes) = state
        
        XCTAssertEqual(count, 2)
        XCTAssertEqual(favoritePrimes, [3, 5, 2])
        XCTAssert(effects.isEmpty)
    }
    
    func testRemoveFavoritePrimeTapped() {
        var state = (count: 3, favoritePrimes: [3, 5])
        
        let effects = primeModalReducer(state: &state, action: .removeFavoritePrimeTapped, environment: ())
        
        let (count, favoritePrimes) = state
        
        XCTAssertEqual(count, 3)
        XCTAssertEqual(favoritePrimes, [5])
        XCTAssert(effects.isEmpty)
    }
    
}
