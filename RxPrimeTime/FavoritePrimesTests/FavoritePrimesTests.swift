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
    private let disposeBag = DisposeBag()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        //CurrentFavoritePrimesEnvironment = .mock
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDeleteAtIndex() {
        let state: FavoritePrimesState = [2, 3, 5, 7]
        
        let favoritePrimeEnvironment = FavoritePrimesEnvironment(
            fileClient: .mock,
            nthPrime: { _ in .sync { nil } }
        )
        
        assert(
            initialValue: state,
            reducer: favoritePrimesReducer,
            environment: favoritePrimeEnvironment,
            steps:
            Step(.send, .deleteFavoritePrimes(0), { $0 = [3, 5, 7] }),
            Step(.send, .deleteFavoritePrimes(2), { $0 = [3, 5] }),
            Step(.send, .deleteFavoritePrimes(10), { $0 = [3, 5] }),
            Step(.send, .deleteFavoritePrimes(-1), { $0 = [3, 5] })
        )
    }
    
    func testLoadButtonTapped() {
        let state: FavoritePrimesState = []
        
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
            reducer: favoritePrimesReducer,
            environment: favoritePrimeEnvironment,
            steps:
            Step(.send, .loadButtonTapped, { $0 = []}),
            Step(.receive, .loadedFavoritePrimes([2, 31]), { $0 = [2, 31] })
        )
    }
    
    func testSaveButtonTapped() {
        let state: FavoritePrimesState = []
        
        let favoritePrimeEnvironment = FavoritePrimesEnvironment(
            fileClient: .mock,
            nthPrime: { _ in  return .sync { 5 } }
        )
        
        assert(
            initialValue: state,
            reducer: favoritePrimesReducer,
            environment: favoritePrimeEnvironment,
            steps:
            Step(.sendSync, .saveButtonTapped, { $0 = [] })
        )
    }

}
