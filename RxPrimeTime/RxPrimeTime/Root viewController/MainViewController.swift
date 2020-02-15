//
//  MainViewController.swift
//  RxPrimeTime
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

import ComposableArchitecture
import SceneBuilder

import Counter
import FavoritePrimes

class MainViewController: UIViewController {

    @IBOutlet var counterViewTap: UIButton!
    @IBOutlet var favoritesPrimesTap: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        counterViewTap.rx.tap.bind { [weak self] in
            guard let self = self else {
                return
            }
            
            navigationLink(from: self,
                           destination: Scene<CounterViewController>(),
                           completion: { vc in
                            
                            vc.store = applicationStore.view(value: { $0.counterView }, action: { .counterView($0) })
            })
        }.disposed(by: disposeBag)
        
        favoritesPrimesTap.rx.tap.bind { [weak self] in
            guard let self = self else {
                return
            }
            
            navigationLink(from: self,
                           destination: Scene<FavoritePrimesViewController>(),
                           completion: { vc in
                            vc.store = applicationStore.view(value: { $0.favoritePrimes }, action: { .favoritePrimes($0) })
            })
        }.disposed(by: disposeBag)
    }
}
