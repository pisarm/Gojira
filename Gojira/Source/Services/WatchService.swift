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
    }

    func sendConfiguration() {

        guard let
            username = Preferences.sharedInstance.observableUsername.value,
            password = Preferences.sharedInstance.observablePassword.value,
            jiraURL = Preferences.sharedInstance.observableJiraURL.value
            else {
                return
        }

        let configuration = [
            ContextType.Username.rawValue : username,
            ContextType.Password.rawValue : password,
            ContextType.JiraURL.rawValue : jiraURL,
        ]

        do {
            try self.updateApplicationContext( configuration )
        } catch {
            print(error)
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
