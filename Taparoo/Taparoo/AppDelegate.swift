//
//  AppDelegate.swift
//  Taparoo
//
//  Created by david padawer on 8/15/17.
//  Copyright © 2017 DPad Studios. All rights reserved.
//

import UIKit
import Skillz

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SkillzDelegate {

    var window: UIWindow?

    //game id: 3870
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        //change with: to SkillzProduction when done
        Skillz.skillzInstance().initWithGameId("3870", for: self, with: SkillzEnvironment.sandbox, allowExit: false)
        window = UIWindow(frame: UIScreen.main.bounds)
        let homeViewController = FirstScreenViewController()
        homeViewController.view.backgroundColor = UIColor.yellow
        window!.rootViewController = homeViewController
        window!.makeKeyAndVisible();

        // Override point for customization after application launch.

        return true
    }

    func preferredSkillzInterfaceOrientation() -> SkillzOrientation {
        return SkillzOrientation.portrait
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }

    func tournamentWillBegin(_ gameParameters: [AnyHashable : Any]!, with matchInfo: SKZMatchInfo!) {
        //let gamePlayViewController = GamePlayViewController()
        //gamePlayViewController.start()

        window = UIWindow(frame: UIScreen.main.bounds)
        let homeViewController = GamePlayViewController()
        homeViewController.view.backgroundColor = UIColor.yellow
        window!.rootViewController = homeViewController
        window!.makeKeyAndVisible();

    }



    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}
