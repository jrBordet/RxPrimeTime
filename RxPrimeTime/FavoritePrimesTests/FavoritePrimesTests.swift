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
@testable import FavoritePrimes

class FavoritePrimesTests: XCTestCase {
    private let disposeBag = DisposeBag()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        CurrentFavoritePrimesEnvironment = .mock
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testErgonomicSaveButtonTapped() {
        let state: FavoritePrimesState = [2, 3, 5, 7]
        
        assert(
            initialValue: state,
            reducer: favoritePrimesReducer,
            steps:
            Step(.send, FavoritePrimesAction.saveButtonTapped) {
                $0.count == 4
            }
        )
        
    }

    func testSaveButtonTapped() {
        var state = [2, 3, 5, 7]
        
        let effects = favoritePrimesReducer(state: &state, action: .saveButtonTapped)
        
        effects[0].subscribe(onNext: { _ in XCTFail() }).disposed(by: disposeBag)
        
        XCTAssertEqual(state, [2, 3, 5, 7])
        XCTAssertEqual(effects.count, 1)
    }
    
    func testLoadFavoritePrimesFlow() {
        var state = [2, 3, 5, 7]
        
        var effects = favoritePrimesReducer(state: &state, action: .loadButtonTapped)
        
        XCTAssertEqual(state, [2, 3, 5, 7])
        XCTAssertEqual(effects.count, 1)
        
        var nextAction: FavoritePrimesAction!
        let receivedCompletion = self.expectation(description: "receivedCompletion")
        
        effects[0]
            .subscribe(onNext: { (action: FavoritePrimesAction) in
                XCTAssertEqual(action, .loadedFavoritePrimes([2, 31]))
                nextAction = action
            }, onCompleted: {
                receivedCompletion.fulfill()
            }).disposed(by: disposeBag)
        
        self.wait(for: [receivedCompletion], timeout: 0)
        
        effects = favoritePrimesReducer(state: &state, action: nextAction)
        
        XCTAssertEqual(state, [2, 31])
        XCTAssert(effects.isEmpty)
    }

}
