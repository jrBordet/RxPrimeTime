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

/**
    We should think of this as a store that is fine-tuned for working directly with views.
    Where stores hold all of the messy business logic of our application,
    and thus may contain a lot more information than our view cares about, the ViewStore will hold only the domain that this view cares about.
    It doesn’t even need to hold the domain of its children views if it doesn’t need that information.
 */


public final class ViewStore<Value, Action> {
    public private(set) var value: BehaviorRelay<Value>
    public let send: (Action) -> Void
    
    private let disposeBag = DisposeBag()
    
    public init(
        initialValue value: Value,
        send: @escaping (Action) -> Void
    ) {
        self.value = BehaviorRelay<Value>(value: value)
        self.send = send
    }
}

/// It can mutate app state (which is captured by the Value generic) given an Action (typically a user action, like a button tap)
/// It’s also handed this Environment type, which holds all of our feature’s dependencies, like API clients, file clients, and anything else that needs to reach into the messy, outside world. And this environment is important, because we must return an array of effects that will be run after our business logic has executed. This is what allows us to interact with the outside world, and feed information from the outside world back into our application.

public typealias Reducer<Value, Action, Environment> = (inout Value, Action, Environment) -> [Effect<Action>]

public final class Store<Value, Action> {
    private let reducer: Reducer<Value, Action, Any>
    
    public private(set) var value: BehaviorRelay<Value>
    
    private let environment: Any
    
    private let disposeBag = DisposeBag()
    
    public init<Environment>(
        initialValue: Value,
        reducer: @escaping Reducer<Value, Action, Environment>,
        environment: Environment
    ) {
        self.reducer = { value, action, environment in
          reducer(&value, action, environment as! Environment)
        }
        
        self.value = BehaviorRelay<Value>(value: initialValue)
        
        self.environment = environment
    }
    
    private func send(_ action: Action) {
        var valueCopy = self.value.value
        let effects = self.reducer(&valueCopy, action, self.environment)
        
        self.value.accept(valueCopy)
        
        effects.forEach { effect in
            effect.subscribe(onNext: { [weak self] (action: Action) in
                self?.send(action)
            }).disposed(by: disposeBag)
        }
    }
    
    public func scope<LocalValue, LocalAction>(
        value toLocalValue: @escaping (Value) -> LocalValue,
        action toGlobalAction: @escaping (LocalAction) -> Action
    ) -> Store<LocalValue, LocalAction> {
        let localStore = Store<LocalValue, LocalAction>(
            initialValue: toLocalValue(self.value.value),
            reducer: { localValue, localAction, _ in
                self.send(toGlobalAction(localAction))
                localValue = toLocalValue(self.value.value)
                return []
        }, environment: self.environment)
        
        self.value.subscribe(onNext: { (newValue: Value) in
            localStore.value.accept(toLocalValue(newValue))
        }).disposed(by: localStore.disposeBag)
        
        return localStore
    }
}

public extension Store where Value: Equatable {
    var view: ViewStore<Value, Action> {
        let viewStore = ViewStore(
            initialValue: self.value.value,
            send: self.send
        )

        self.value
            .distinctUntilChanged()
            .bind(to: viewStore.value)
            .disposed(by: disposeBag)

        return viewStore
    }
}

public func combine<Value, Action, Environment>(
    _ reducers: Reducer<Value, Action, Environment>...
) -> Reducer<Value, Action, Environment> {
    return { value, action, environment in
        let effects = reducers.flatMap {
            $0(&value, action, environment)
        }
        
        return effects
    }
}

/**
 
 Then inside here we have access to a global value and a reducer that works on local values.
 So, we can use the key path to extract the local value from the global value,
 run the reducer on that local value, and then plug that local value back into the global value:
 
 */

public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction, LocalEnvironment, GlobalEnvironment>(
    _ reducer: @escaping Reducer<LocalValue, LocalAction, LocalEnvironment>,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>,
    environment: @escaping (GlobalEnvironment) -> LocalEnvironment
) -> Reducer<GlobalValue, GlobalAction, GlobalEnvironment> {
    return { globalValue, globalAction, globalEnvironment in
        guard let localAction = globalAction[keyPath: action] else {
            return []
        }
        //  var localValue = globalValue[keyPath: value]
        //  reducer(&localValue, action)
        //  globalValue[keyPath: value] = localValue
        
        // WritableKeyPath<GlobalValue, LocalValue>
        // \User.id as WritableKeyPath<User, Int>
        let localEffects = reducer(&globalValue[keyPath: value], localAction, environment(globalEnvironment))
        
        return localEffects.map { localEffect in
            localEffect.map { localAction -> GlobalAction in
                var globalAction = globalAction
                globalAction[keyPath: action] = localAction
                return globalAction
            }
        }
    }
}

public func logging<Value, Action, Environment>(
    _ reducer: @escaping Reducer<Value, Action, Environment>
) -> Reducer<Value, Action, Environment> {
    return { value, action, environment in
        let effects = reducer(&value, action, environment)
        let newValue = value
        
        return [.fireAndForget {
            print("Action: \(action)")
            print("Value:")
            dump(newValue)
            print("---")
            }] + effects
    }
}
