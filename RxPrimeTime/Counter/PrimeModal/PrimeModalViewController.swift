//
//  PrimeModalViewController.swift
//  Counter
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ComposableArchitecture
import SceneBuilder

extension PrimeModalViewController.State {
  init(primeModalState state: PrimeModalState) {
    self.count = state.count
    self.isFavorite = state.favoritePrimes.contains(state.count)
  }
}

public class PrimeModalViewController: UIViewController {
    struct State: Equatable {
      let count: Int
      let isFavorite: Bool
    }
    
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var actionsContainer: UIStackView!
    @IBOutlet var removeFavoriteButton: UIButton!
    @IBOutlet var addFavoriteButton: UIButton!
    @IBOutlet var dismissButton: UIButton!
    
    public var store: Store<PrimeModalState, PrimeModalAction>?
    var viewStore: ViewStore<State, PrimeModalAction>?
    
    private let disposeBag = DisposeBag()
    
    public convenience init(store: Store<PrimeModalState, PrimeModalAction>) {
        guard let nib = (String(describing: type(of: self)) as NSString).components(separatedBy: ".").first else {
            fatalError()
        }
        
        self.init(nibName: nib, bundle: Bundle(for: PrimeModalViewController.self))
        
        self.store = store
        
        self.viewStore = store.scope(
            value: PrimeModalViewController.State.init(primeModalState:), action: { $0 }
        ).view
    }
    
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
        
        if #available(iOS 13, *) {
            dismissButton.isHidden = true
        } else {
            dismissButton.isHidden = false
        }
        
        guard
            let store = self.store,
            let viewStore = self.viewStore else {
            return
        }
        
        viewStore
            .value
            .map { isPrime($0.count) ? "\($0.count) is prime 🎉" : "\($0.count) is not prime 😅" }
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewStore
            .value
            .map { isPrime($0.count) }
            .bind(to: actionsContainer.rx.isVisible)
            .disposed(by: disposeBag)
                
        let isFavorite = viewStore
            .value
            .map { $0.isFavorite }
            .share(replay: 1, scope: .forever)
            
        isFavorite
            .bind(to: addFavoriteButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        isFavorite
            .bind(to: removeFavoriteButton.rx.isVisible)
            .disposed(by: disposeBag)
                
        addFavoriteButton.rx
            .tap.bind { viewStore.send(PrimeModalAction.saveFavoritePrimeTapped) }
            .disposed(by: disposeBag)
        
        removeFavoriteButton.rx
            .tap.bind { viewStore.send(.removeFavoritePrimeTapped) }
            .disposed(by: disposeBag)
        
        dismissButton.rx.tap.bind { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
}
