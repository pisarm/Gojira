//
//  AppDelegate.swift
//  Gojira
//
//  Created by Flemming Pedersen on 21/10/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)

        WatchService.sharedInstance.startSession()

        return true
    }
}

extension AppDelegate {
    //MARK: Background fetch
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        let oldTotal = DataService.sharedInstance.observableTotal.value
        DataService.sharedInstance.observableTotal
            .observeNew {
                guard let oldTotal = oldTotal, newTotal = $0 else {
                    completionHandler(.NoData)
                    return
                }

                if oldTotal == newTotal {
                    completionHandler(.NoData)
                } else {
                    completionHandler(.NewData)
                }
        }
    }
}
