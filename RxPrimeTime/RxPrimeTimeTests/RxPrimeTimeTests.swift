//
//  RxPrimeTimeTests.swift
//  RxPrimeTimeTests
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import XCTest
@testable import RxPrimeTime
import ComposableArchitecture
import Counter
import FavoritePrimes

class RxPrimeTimeTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testApp() {
        //        assert(initialValue: CounterViewState(count: 2,
        //                                              favoritePrimes: [2, 3],
        //                                              isLoading: false,
        //                                              alertNthPrime: nil),
        //               reducer: counterViewReducer,
        //               environment: { _  in Effect.sync { 3 } },
        //               steps:
        //            Step(.send, .counter(.incrTapped)) { $0.count = 3 },
        //               Step(.send, CounterViewAction.counter(CounterAction.decrTapped), { $0.count = 2 })
        //        )
        
//        let appState = AppState(count: 1,
//                                favoritePrimes: [2, 3],
//                                isLoading: false)
//        
//        assert(initialValue: appState,
//               reducer: appReducer,
//               environment: appEnvironment,
//               steps: Step(.send, AppAction.counterView(CounterViewAction.counter(CounterAction.incrTapped)), {
//                appState in appState.isLoading = false
//               })
//        )
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
