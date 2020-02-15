//
//  CounterViewController.swift
//  Counter
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ComposableArchitecture
import SwiftSpinner
import SceneBuilder

public class CounterViewController: UIViewController {
    @IBOutlet var decrButton: UIButton!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var incrButton: UIButton!
    @IBOutlet var isPrimeModalShown: UIButton!
    @IBOutlet var isNthPrimeButton: UIButton!
    
    public var store: Store<CounterViewState, CounterViewAction>?
    
    private let disposeBag = DisposeBag()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        guard let store = self.store else {
            return
        }
        
        store
            .value
            .map { $0.isLoading }
            .asDriver(onErrorJustReturn: false)
            .drive(SwiftSpinner.shared.rx_visible)
            .disposed(by: disposeBag)
        
        store
            .value
            .map { String($0.count) }
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
        
        decrButton.rx.tap.bind {
            store.send(.counter(.decrTapped))
        }.disposed(by: disposeBag)
        
        incrButton.rx.tap.bind {
            store.send(.counter(.incrTapped))
        }.disposed(by: disposeBag)
        
        isPrimeModalShown.rx.tap.bind {
            navigationLink(from: self,
                           destination: Scene<PrimeModalViewController>(),
                           completion: { vc in
                            vc.store = store.view(value: { ($0.count, $0.favoritePrimes) }, action: { .primeModal($0) })
            }, isModal: true)
            
        }.disposed(by: disposeBag)
        
        store
            .value
            .map { "What is the \(String($0.count))rd prime?" }
            .bind(to: isNthPrimeButton.rx.title())
            .disposed(by: disposeBag)
        
        isNthPrimeButton.rx.tap.bind {
            store.send(.counter(.nthPrimeButtonTapped))
        }.disposed(by: disposeBag)
        
        store
            .value
            .map { (count: $0.count, prime: $0.alertNthPrime?.prime) }
            .distinctUntilChanged { $0.prime == nil && $1.prime == nil }
            .asDriver(onErrorJustReturn: (0, nil))
            .drive(onNext: { [weak self] (count: Int, nthPrime: Int?) in
                guard
                    let self = self,
                    let nthPrime = nthPrime else {
                        return
                }
                
                let alert = UIAlertController(title: nil, message: "The \(ordinal(count)) prime is \(nthPrime)", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    store.send(.counter(.alertDismissButtonTapped))
                }))
                
                self.present(alert, animated: true)
            }).disposed(by: disposeBag)
    }
}

func ordinal(_ n: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal
    return formatter.string(for: n) ?? ""
}
