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
    private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    private var validSession: WCSession? {
        if let session = session where session.paired && session.watchAppInstalled {
            return session
        }
        return nil
    }

    static let sharedInstance = WatchService()

    private override init() {
        super.init()
    }

    func startSession() {
        session?.delegate = self
        session?.activateSession()

        setupBonds()
    }

    private func setupBonds() {
        Preferences.sharedInstance.observableUsername
            .observe {
                if let username = $0 {
                    do {
                        try self.updateApplicationContext( [ContextType.Username.rawValue : username] )
                    } catch { print(error) }
                }
        }

        Preferences.sharedInstance.observablePassword
            .observe {
                if let password = $0 {
                    do {
                        try self.updateApplicationContext( [ContextType.Password.rawValue : password] )
                    } catch { print(error) }
                }
        }

        Preferences.sharedInstance.observableJiraURL
            .observe {
                if let jiraURL = $0 {
                    do {
                        try self.updateApplicationContext( [ContextType.JiraURL.rawValue : jiraURL] )
                    } catch { print(error) }
                }
        }
    }
}

extension WatchService {
    func updateApplicationContext(applicationContext: [String : AnyObject]) throws {
        if let session = validSession {
            try session.updateApplicationContext(applicationContext)
        }
    }
}
