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
    
    public var store: Store<FavoritePrimesState, FavoritePrimesAction>?
    
    private let disposeBag = DisposeBag()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        //        let favoritePrimeEnvironment = FavoritePrimesEnvironment(
        //            fileClient: .live,
        //            nthPrime: { _ in  return Effect.sync { 5 } }
        //        )
        //
        //        store = Store(
        //            initialValue: [2, 3, 5],
        //            reducer: favoritePrimesReducer,
        //            environment: favoritePrimeEnvironment
        //        )
        
        guard let store = store else {
            return
        }
        
        let dataSource =
            store
                .value
                .flatMapLatest { favorites -> Observable<[String]> in
                    .just(favorites.map { "\($0)" })
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
                
                store.send(.deleteFavoritePrimes(item))
        }
        .disposed(by: disposeBag)
        
        tableView
            .rx
            .modelSelected(String?.self)
            .subscribe(onNext: { [weak self] (model: String?) in
                guard let self = self else {
                    return
                }
                
                let alert = UIAlertController(
                    title: nil,
                    message: "The  prime is \(model ?? "")",
                    preferredStyle: .alert
                )
                
                alert.addAction(
                    UIAlertAction(
                        title: "Ok",
                        style: .default,
                        handler: nil)
                )
                
                self.present(alert, animated: true)
            }).disposed(by: disposeBag)
        
        loadButton
            .rx
            .tap
            .bind {
                store.send(.loadButtonTapped)
        }.disposed(by: disposeBag)
        
        saveButton
            .rx
            .tap
            .bind {
                store.send(.saveButtonTapped)
        }.disposed(by: disposeBag)
    }
}
