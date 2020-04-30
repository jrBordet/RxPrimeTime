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
    public var viewStore: ViewStore<FavoritePrimesState>?
    
    private let disposeBag = DisposeBag()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        //store = Store(initialValue: [2, 3, 5], reducer: favoritePrimesReducer(state:action:))
        
        guard
            let store = store,
            let viewStore = viewStore else {
            return
        }
        
        let dataSource =
            viewStore
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
