//
//  WatchService.swift
//  Gojira
//
//  Created by Flemming Pedersen on 29/10/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//

import WatchConnectivity

class WatchService: NSObject, WCSessionDelegate {
    static let sharedInstance = WatchService()
    private override init() {
        super.init()
    }

    private let session: WCSession = WCSession.defaultSession()

    func startSession() {
        session.delegate = self
        session.activateSession()
    }
}

extension WatchService {
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        print(applicationContext)
        DataService.sharedInstance.set(applicationContext)
    }
}
