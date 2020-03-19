//
//  RxPrimeTimeTests.swift
//  RxPrimeTimeTests
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import XCTest
import ComposableArchitecture
import Counter
import FavoritePrimes
import FileClient
@testable import RxPrimeTime

class RxPrimeTimeTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testApp() {
//        let test = FileClient(
//            load: { _ in Effect<Data?>.sync {
//                try! JSONEncoder().encode([2, 31])
//                }
//        },
//            save: { _, _ in .fireAndForget {} }
//        )
//        
//        let appTestEnvironment = AppEnvironment(
//            fileClient: test,
//            nthPrime: { _ in Effect.sync { 3 } }
//        )
//
//        let testInitialAppState = AppState(
//            count: 0,
//            favoritePrimes: [],
//            isLoading: false
//        )
        
//        assert(
//            initialValue: testInitialAppState,
//            reducer: appReducer,
//            environment: appTestEnvironment,
//            steps: Step(.send, .counterView(.counter(.incrTapped)), { state in
//                //state.count = 1
//            })
//        )
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
