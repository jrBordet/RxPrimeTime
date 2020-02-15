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

public class PrimeModalViewController: UIViewController {
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var actionsContainer: UIStackView!
    @IBOutlet var removeFavoriteButton: UIButton!
    @IBOutlet var addFavoriteButton: UIButton!
    
    public var store: Store<PrimeModalState, PrimeModalAction>?
    
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
        
        guard let store = self.store else {
            return
        }
        
        store
            .value
            .map { isPrime($0.count) ? "\($0.count) is prime 🎉" : "\($0.count) is not prime 😅" }
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
        
        store
            .value
            .map { isPrime($0.count) }
            .bind(to: actionsContainer.rx.isVisible)
            .disposed(by: disposeBag)
                
        let isFavorite =
            store
                .value
                .map { $0.favoritePrimes.contains($0.count) }
                .share(replay: 1, scope: .forever)
            
        isFavorite
            .bind(to: addFavoriteButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        isFavorite
            .bind(to: removeFavoriteButton.rx.isVisible)
            .disposed(by: disposeBag)
        
        addFavoriteButton.rx
            .tap.bind { store.send(.saveFavoritePrimeTapped) }
            .disposed(by: disposeBag)
        
        removeFavoriteButton.rx
            .tap.bind { store.send(.removeFavoritePrimeTapped) }
            .disposed(by: disposeBag)
    }
}