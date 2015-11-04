//
//  WatchService.swift
//  Gojira
//
//  Created by Flemming Pedersen on 23/10/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//

import Bond
import WatchConnectivity

class WatchService: NSObject, WCSessionDelegate {
    static let sharedInstance = WatchService()
    private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    private var validSession: WCSession? {
        if let session = session where session.paired && session.watchAppInstalled {
            return session
        }
        return nil
    }

    private override init() {
        super.init()
    }

    func startSession() {
        session?.delegate = self
        session?.activateSession()

        DataService.sharedInstance.observableQuery
            .observe {
                if let query = $0{
                    do {
                        try self.updateApplicationContext(["Query" : query])
                    } catch { print(error) }
                }
        }

        DataService.sharedInstance.observableTitle
            .observe {
                if let title = $0 {
                    do {
                        try self.updateApplicationContext(["Title": title])
                    } catch { print(error) }
                }
        }
    }
}

extension WatchService {
    // Sender
    func updateApplicationContext(applicationContext: [String : AnyObject]) throws {
        if let session = validSession {
            try session.updateApplicationContext(applicationContext)
        }
    }

    // Receiver
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
    }
}