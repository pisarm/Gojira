//
//  DataService.swift
//  Gojira
//
//  Created by Flemming Pedersen on 24/10/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//

import Bond
import Foundation
import Locksmith

private enum PreferenceType: String {
    case Username
    case Password
    case JiraURL
}

final class Preferences {
    //MARK: Observables
    lazy var observableUsername: Observable<String?> = {
        guard let username = self.preference(forKey: .Username) as? String else {
            return Observable("")
        }

        return Observable(username)
    }()

    lazy var observablePassword: Observable<String?> = {
        guard let password = self.preference(forKey: .Password) as? String else {
            return Observable("")
        }

        return Observable(password)
    }()

    lazy var observableJiraURL: Observable<String?> = {
        guard let jiraURL = self.preference(forKey: .JiraURL) as? String else {
            return Observable("")
        }

        return Observable(jiraURL)
    }()

    //MARK: Properties
    static let sharedInstance = Preferences()
    private let userAccount = "dk.pisarm.gojira.preferences"
    private var preferenceData: [String : AnyObject] = [:]

    //MARK: Init
    init() {
        loadData()
        setupBonds()
    }

    private func loadData() {
        guard let loadedData = Locksmith.loadDataForUserAccount(userAccount) else {
            return
        }

        preferenceData = loadedData
    }

    private func setupBonds() {
        observableUsername.observeNew { self.setPreference($0, forKey: .Username) }
        observablePassword.observeNew { self.setPreference($0, forKey: .Password) }
        observableJiraURL.observeNew { self.setPreference($0, forKey: .JiraURL) }
    }

    //MARK: Set and get
    private func setPreference(value: AnyObject?, forKey key: PreferenceType) {
        guard let value = value else {
            return
        }

        preferenceData[key.rawValue] = value

        do {
            try Locksmith.updateData(preferenceData, forUserAccount: userAccount)
        } catch {
            print(error)
        }
    }

    private func preference(forKey key: PreferenceType) -> AnyObject? {
        guard let preference = preferenceData[key.rawValue] else {
            return nil
        }

        return preference
    }

}
