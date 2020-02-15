//
//  CounterTests.swift
//  CounterTests
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import XCTest
@testable import Counter

class CounterTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: Prime modal
    
    func testSaveFavoritePrimesTapped() {
        var state = (count: 2, favoritePrimes: [3, 5])
        
        let effects = primeModalReducer(state: &state, action: .saveFavoritePrimeTapped)
        
        // If prime modal state ever changes, this will fail to compile,
        // forcing us to make changes to our test.
        let (count, favoritePrimes) = state
        
        XCTAssertEqual(count, 2)
        XCTAssertEqual(favoritePrimes, [3, 5, 2])
        XCTAssert(effects.isEmpty)
    }
    
    func testRemoveFavoritePrimeTapped() {
        var state = (count: 3, favoritePrimes: [3, 5])
        
        let effects = primeModalReducer(state: &state, action: .removeFavoritePrimeTapped)
        
        let (count, favoritePrimes) = state
        
        XCTAssertEqual(count, 3)
        XCTAssertEqual(favoritePrimes, [5])
        XCTAssert(effects.isEmpty)
    }

}
