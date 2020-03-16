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
@testable import FavoritePrimes

class FavoritePrimesTests: XCTestCase {
    private let disposeBag = DisposeBag()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        //CurrentFavoritePrimesEnvironment = .mock
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testErgonomicDeleteAtIndex() {
        let state: FavoritePrimesState = [2, 3, 5, 7]
        
        let favoritePrimeEnvironment = FavoritePrimesEnvironment(
            fileClient: .live,
            nthPrime: { _ in  return Effect.sync { 5 } }
        )
        
        assert(
            initialValue: state,
            reducer: favoritePrimesReducer,
            environment: favoritePrimeEnvironment,
            steps:
            Step(.send, .deleteFavoritePrimes(0), {
                $0 = [3, 5, 7]
            }),
            Step(.send, .deleteFavoritePrimes(2), {
                $0 = [3, 5]
            })
        )
    }
    
    func testErgonomicSaveButtonTapped() {
        let state: FavoritePrimesState = []
        
        let favoritePrimeEnvironment = FavoritePrimesEnvironment(
            fileClient: .live,
            nthPrime: { _ in  return Effect.sync { 5 } }
        )
        
        assert(
            initialValue: state,
            reducer: favoritePrimesReducer,
            environment: favoritePrimeEnvironment,
            steps:
            Step(.send, .loadButtonTapped, {
               $0 = [2, 3, 5, 7]
            })
        )
        
        /**
         
         
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
         
         */
        
        
//        assert(
//            initialValue: state,
//            reducer: favoritePrimesReducer,
//            steps:
//            Step(.send, FavoritePrimesAction.saveButtonTapped) {
//                $0.count == 4
//            }
//        )
        
    }

    func testSaveButtonTapped() {
        var state = [2, 3, 5, 7]
        
//        let effects = favoritePrimesReducer(state: &state, action: .saveButtonTapped)
//
//        effects[0].subscribe(onNext: { _ in XCTFail() }).disposed(by: disposeBag)
//
//        XCTAssertEqual(state, [2, 3, 5, 7])
//        XCTAssertEqual(effects.count, 1)
    }
    
    func testLoadFavoritePrimesFlow() {
//        var state = [2, 3, 5, 7]
//
//        var effects = favoritePrimesReducer(state: &state, action: .loadButtonTapped)
//
//        XCTAssertEqual(state, [2, 3, 5, 7])
//        XCTAssertEqual(effects.count, 1)
//
//        var nextAction: FavoritePrimesAction!
//        let receivedCompletion = self.expectation(description: "receivedCompletion")
//
//        effects[0]
//            .subscribe(onNext: { (action: FavoritePrimesAction) in
//                XCTAssertEqual(action, .loadedFavoritePrimes([2, 31]))
//                nextAction = action
//            }, onCompleted: {
//                receivedCompletion.fulfill()
//            }).disposed(by: disposeBag)
//
//        self.wait(for: [receivedCompletion], timeout: 0)
//
//        effects = favoritePrimesReducer(state: &state, action: nextAction)
//
//        XCTAssertEqual(state, [2, 31])
//        XCTAssert(effects.isEmpty)
    }

}
