//
//  RxPrimeTimeTests.swift
//  RxPrimeTimeTests
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import XCTest
@testable import RxPrimeTime
//import Counter

class RxPrimeTimeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Counter
    
//    func testErgonomicIncrDecrButtonTapped() {
//        assert(
//            initialValue: CounterViewState(count: 2),
//            reducer: counterViewReducer,
//            steps:
//            Step(.send, .counter(.incrTapped)) { $0.count = 3 },
//            Step(.send, .counter(.incrTapped)) { $0.count = 4 },
//            Step(.send, .counter(.decrTapped)) { $0.count = 3 }
//        )
//    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
