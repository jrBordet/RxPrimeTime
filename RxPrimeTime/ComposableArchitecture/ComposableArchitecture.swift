//
//  ComposableArchitecture.swift
//  ComposableArchitecture
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public typealias Effect<A> = Observable<A>

public typealias Reducer<Value, Action> = (inout Value, Action) -> [Effect<Action>]

public final class Store<Value, Action> {
    private let reducer: Reducer<Value, Action>
    
    public private(set) var value: BehaviorRelay<Value>
    
    private let disposeBag = DisposeBag()
    
    public init(initialValue: Value, reducer: @escaping Reducer<Value, Action>) {
        self.reducer = reducer
        self.value = BehaviorRelay<Value>(value: initialValue)
    }
    
    public func send(_ action: Action) {
        var valueCopy = self.value.value
        let effects = self.reducer(&valueCopy, action)
        
        self.value.accept(valueCopy)
        
        effects.forEach { effect in
            effect.subscribe(onNext: { [weak self] (action: Action) in
                self?.send(action)
            }).disposed(by: disposeBag)
        }
    }
    
    public func view<LocalValue, LocalAction>(
        value toLocalValue: @escaping (Value) -> LocalValue,
        action toGlobalAction: @escaping (LocalAction) -> Action
    ) -> Store<LocalValue, LocalAction> {
        let localStore = Store<LocalValue, LocalAction>(
            initialValue: toLocalValue(self.value.value),
            reducer: { localValue, localAction in
                self.send(toGlobalAction(localAction))
                localValue = toLocalValue(self.value.value)
                return []
        })
        
        self.value.subscribe(onNext: { (newValue: Value) in
            localStore.value.accept(toLocalValue(newValue))
        }).disposed(by: localStore.disposeBag)
        
        return localStore
    }
}

public func combine<Value, Action>(
    _ reducers: Reducer<Value, Action>...
) -> Reducer<Value, Action> {
    return { value, action in
        let effects = reducers.flatMap {
            $0(&value, action)
        }
        
        return effects
    }
}

/**
 
 Then inside here we have access to a global value and a reducer that works on local values.
 So, we can use the key path to extract the local value from the global value,
 run the reducer on that local value, and then plug that local value back into the global value:
 
 */

public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
    _ reducer: @escaping Reducer<LocalValue, LocalAction>,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>
) -> Reducer<GlobalValue, GlobalAction> {
    return { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: action] else {
            return []
        }
        //  var localValue = globalValue[keyPath: value]
        //  reducer(&localValue, action)
        //  globalValue[keyPath: value] = localValue
        
        // WritableKeyPath<GlobalValue, LocalValue>
        // \User.id as WritableKeyPath<User, Int>
        let localEffects = reducer(&globalValue[keyPath: value], localAction)
        
        return localEffects.map { localEffect in
            localEffect.map { localAction -> GlobalAction in
                var globalAction = globalAction
                globalAction[keyPath: action] = localAction
                return globalAction
            }
        }
    }
}

public func logging<Value, Action>(
    _ reducer: @escaping Reducer<Value, Action>
) -> Reducer<Value, Action> {
    return { value, action in
        let effects = reducer(&value, action)
        let newValue = value
        
        return [.fireAndForget {
            print("Action: \(action)")
            print("Value:")
            dump(newValue)
            print("---")
            }] + effects
    }
}
