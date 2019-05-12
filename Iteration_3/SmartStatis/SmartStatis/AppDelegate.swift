//
//  AppDelegate.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/3/29.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge, .carPlay], completionHandler: { (granted, error) in
            if granted {
                print("allow")
            } else {
                print("Not allow")
            }
        })
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        let controllerOne = window?.rootViewController as! GuestViewController
        var controllerTwo: TabBarViewController?
        var homeNavigation: UINavigationController?
        var home: HomePageController?
        if controllerOne.presentedViewController != nil {
            controllerTwo = controllerOne.presentedViewController as? TabBarViewController
            if controllerTwo!.viewControllers?.first != nil {
                homeNavigation = controllerTwo!.viewControllers?.first as? UINavigationController
                if homeNavigation!.viewControllers.first != nil {
                    home = homeNavigation!.viewControllers.first as? HomePageController
                    home?.checkFoodDateForNotification()
                }
            }
            
        }
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        let controllerOne = window?.rootViewController as! GuestViewController
        var controllerTwo: TabBarViewController?
        var homeNavigation: UINavigationController?
        var home: HomePageController?
        if controllerOne.presentedViewController != nil {
            controllerTwo = controllerOne.presentedViewController as? TabBarViewController
            if controllerTwo?.viewControllers?.first != nil {
                homeNavigation = controllerTwo?.viewControllers?.first as? UINavigationController
                if homeNavigation?.viewControllers.first != nil {
                    home = homeNavigation!.viewControllers.first as? HomePageController
                    home?.checkFoodDateForNotification()
                }
            }
            
        }
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

    // MARK: - Core Data stack


    // MARK: - Core Data Saving support


}

