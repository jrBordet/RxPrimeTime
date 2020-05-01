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

public extension CounterViewController.State {
  init(counterFeatureState: CounterFeatureState) {
    self.alertNthPrime = counterFeatureState.alertNthPrime
    self.count = counterFeatureState.count
    self.isLoading = counterFeatureState.isLoading
//    self.isNthPrimeButtonDisabled = true//counterFeatureState.isNthPrimeRequestInFlight
//    self.isPrimeModalShown = true//counterFeatureState.isPrimeModalShown
//    self.isIncrementButtonDisabled = true//counterFeatureState.isNthPrimeRequestInFlight
//    self.isDecrementButtonDisabled = true//counterFeatureState.isNthPrimeRequestInFlight
  }
}

public extension CounterFeatureAction {
    init(action: CounterViewController.Action) {
        switch action {
        case .decrTapped:
            self = .counter(CounterAction.decrTapped)
        case .incrTapped:
            self = .counter(CounterAction.incrTapped)
        case .nthPrimeButtonTapped:
            self = .counter(CounterAction.requestNthPrime)
        case .alertDismissButtonTapped:
            self = .counter(CounterAction.alertDismissButtonTapped)
        case .isPrimeButtonTapped:
            // TODO: - check this
            self = .counter(CounterAction.alertDismissButtonTapped)
        case .doubleTap:
             // TODO: - check this
            self = .counter(CounterAction.alertDismissButtonTapped)
        }
//        switch action {
//        case .decrTapped:
//            self = .counter(.decrTapped)
//        case .incrTapped:
//            self = .counter(.incrTapped)
//        case .nthPrimeButtonTapped:
//            self = .counter(.requestNthPrime)
//        case .alertDismissButtonTapped:
//            self = .counter(.alertDismissButtonTapped)
//        case .isPrimeButtonTapped:
//            self = .counter(.isPrimeButtonTapped)
//        case .primeModalDismissed:
//            self = .counter(.primeModalDismissed)
//        case .doubleTap:
//            self = .counter(.requestNthPrime)
//        }
    }
}

public class CounterViewController: UIViewController {
    public struct State: Equatable {
      let alertNthPrime: PrimeAlert?
      let count: Int
      let isLoading: Bool
//      let isNthPrimeButtonDisabled: Bool
//      let isPrimeModalShown: Bool
//      let isIncrementButtonDisabled: Bool
//      let isDecrementButtonDisabled: Bool
    }
    
    public enum Action {
      case decrTapped
      case incrTapped
      case nthPrimeButtonTapped
      case alertDismissButtonTapped
      case isPrimeButtonTapped
//      case primeModalDismissed
      case doubleTap
    }
    
    @IBOutlet var decrButton: UIButton!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var incrButton: UIButton!
    @IBOutlet var isPrimeModalShown: UIButton!
    @IBOutlet var isNthPrimeButton: UIButton!
    
    public var store: Store<CounterFeatureState, CounterFeatureAction>?
    public var viewStore: ViewStore<State, Action>?
    
    private let disposeBag = DisposeBag()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        guard
            let store = self.store,
            let viewStore = self.viewStore else {
            return
        }
        
//        Store<CounterViewState, CounterViewAction>.init(initialValue: CounterViewState(count: 0, favoritePrimes: [], isLoading: false, alertNthPrime: nibName), reducer: counterViewReducer)
        
        viewStore
            .value
            .debug("[\(self.debugDescription)]", trimOutput: false)
            .map { $0.isLoading }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(SwiftSpinner.shared.rx_visible)
            .disposed(by: disposeBag)
        
        viewStore
            .value
            .map { $0.isLoading == false}
            .asDriver(onErrorJustReturn: false)
            .drive(isNthPrimeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewStore
            .value
            .map { String($0.count) }
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
        
        decrButton.rx.tap.bind {
            viewStore.send(CounterViewController.Action.decrTapped)
        }.disposed(by: disposeBag)
        
        incrButton.rx.tap.bind {
            viewStore.send(CounterViewController.Action.incrTapped)
        }.disposed(by: disposeBag)
        
        isPrimeModalShown.rx.tap.bind { [weak self] in
            let vc = PrimeModalViewController(
                store: store.scope(
                    value: { ($0.count, $0.favoritePrimes) },
                    action: { .primeModal($0) }
            ))
            
            self?.present(vc, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        viewStore
            .value
            .map { "What is the \(String($0.count))rd prime?" }
            .bind(to: isNthPrimeButton.rx.title())
            .disposed(by: disposeBag)
        
        isNthPrimeButton.rx.tap.bind {
            viewStore.send(.nthPrimeButtonTapped)
            //store.send(.counter(.nthPrimeButtonTapped))
        }.disposed(by: disposeBag)
        
        viewStore
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
                    viewStore.send(CounterViewController.Action.alertDismissButtonTapped)
                   // viewStore.send(.counter(.alertDismissButtonTapped))
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
