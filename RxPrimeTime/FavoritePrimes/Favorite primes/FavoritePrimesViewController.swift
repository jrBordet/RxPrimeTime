//
//  FavoritePrimesViewController.swift
//  FavoritePrimes
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ComposableArchitecture
import SwiftSpinner

public class FavoritePrimesViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var saveButton: UIButton! {
        didSet {
            saveButton.layer.cornerRadius = saveButton.frame.width / 2
        }
    }
    
    @IBOutlet var loadButton: UIButton!  {
        didSet {
            loadButton.layer.cornerRadius = loadButton.frame.width / 2
        }
    }
    
    public var store: Store<FavoritePrimesViewState, FavoritePrimesViewAction>?
    
    private let disposeBag = DisposeBag()
    
    deinit {
        print("[deinit] \(self.description)")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        
        //        Debug
        //        let favoritePrimeEnvironment = FavoritePrimesEnvironment(
        //            fileClient: .live,
        //            nthPrime: { _ in  return Effect.sync { 5 } }
        //        )
        //
        //        store = Store(
        //            initialValue: FavoritePrimesViewState(
        //                favoritePrimes: [2, 3, 5, 7],
        //                isLoading: false,
        //                alertNthPrime: nil
        //            ),
        //            reducer: favoritePrimesViewReducer,
        //            environment: favoritePrimeEnvironment
        //        )
        
        guard let store = store else {
            return
        }
        
        store
            .value
            .map { $0.isLoading }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(SwiftSpinner.shared.rx_visible)
            .disposed(by: disposeBag)
        
        let dataSource =
            store
                .value
                .flatMapLatest { state -> Observable<[String]> in
                    .just(state.favoritePrimes.map { "\($0)" })
            }.share(replay: 1, scope: .forever)
        
        dataSource
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { index, model, cell in
                cell.textLabel?.text = model
        }
        .disposed(by: disposeBag)
        
        tableView
            .rx
            .itemDeleted
            .subscribe {
                guard let item = $0.element?.row else {
                    return
                }
                
                store.send(.favorites(.deleteFavoritePrimes(item)))
        }
        .disposed(by: disposeBag)
        
        tableView
            .rx
            .modelSelected(String?.self)
            .subscribe(onNext: { (model: String?) in
                guard
                    let smodel = model,
                    let intModel = Int(smodel) else {
                        return
                }
                
                store.send(.favorites(.nthPrimeButtonTapped(intModel)))
            }).disposed(by: disposeBag)
        
        store
            .value
            .map { $0.alertNthPrime }
            .debug("[\(self.debugDescription)]", trimOutput: false)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] (alert: NthPrimeAlert?) in
                guard
                    let self = self,
                    let prime = alert?.prime else {
                    return
                }
                
                let alert = UIAlertController(
                    title: nil,
                    message: "The  prime is \(prime)",
                    preferredStyle: .alert
                )
                
                alert.addAction(
                    UIAlertAction(
                        title: "Ok",
                        style: .default,
                        handler: nil)
                )
                
                self.present(
                    alert,
                    animated: true
                )
            }).disposed(by: disposeBag)
        
        loadButton
            .rx
            .tap
            .bind {
                store.send(.favorites(.loadButtonTapped))
        }.disposed(by: disposeBag)
        
        saveButton
            .rx
            .tap
            .bind {
                store.send(.favorites(.saveButtonTapped))
        }.disposed(by: disposeBag)
    }
}
