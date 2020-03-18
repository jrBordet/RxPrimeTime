//
//  AppDelegate.swift
//  RxPrimeTime
//
//  Created by Jean Raphael Bordet on 15/02/2020.
//  Copyright © 2020 Bordet. All rights reserved.
//

import UIKit
import SceneBuilder
import ComposableArchitecture
import Counter
import FavoritePrimes
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootScene = Scene<MainViewController>().render()
        
        self.window?.rootViewController = UINavigationController(rootViewController: rootScene)
        
        self.window?.makeKeyAndVisible()
        self.window?.backgroundColor = .white
        
        #if DEBUG
        
        _ = Observable<Int>
            .interval(1, scheduler: MainScheduler.instance)
            .map { _ in Int(RxSwift.Resources.total) }
            .distinctUntilChanged()
            .subscribe(onNext: { _ in
                print("[Resource] count \(RxSwift.Resources.total)")
            })
        
        #endif
        
        return true
    }
}
