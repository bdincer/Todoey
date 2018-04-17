//
//  AppDelegate.swift
//  Todoey
//
//  Created by Bora Dincer on 4/10/18.
//  Copyright © 2018 Bora Dincer. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        do {
             _ = try Realm()
        }catch{
            print(error)
        }
        return true
    }

    

    


}

