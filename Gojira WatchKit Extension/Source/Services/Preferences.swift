//
//  PreferencesService.swift
//  Gojira
//
//  Created by Flemming Pedersen on 29/10/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//

import Foundation
import Locksmith

enum RefreshType: Double {
    case Ten = 600
    case Twenty = 1200
    case Thirty = 1800
    case Fourty = 2400
    case Fifty = 3000
    case Sixty = 3600

    var description: String {
        switch self {
        case .Ten:
            return "10 mins"
        case .Twenty:
            return "20 mins"
        case .Thirty:
            return "30 mins"
        case .Fourty:
            return "40 mins"
        case .Fifty:
            return "50 mins"
        case .Sixty:
            return "60 mins"
        }
    }
}

private enum PreferenceType: String {
    case Refresh
    case Title
}

final class Preferences {
    //MARK: Stored in keychain
    var username: String? {
            guard let value = preference(forKey: .Username) as? String else {
                return nil
            }

            return value
    }

    var password: String? {
            guard let value = preference(forKey: .Password) as? String else {
                return nil
            }

            return value
    }

    var jiraURL: String? {
            guard let value = preference(forKey: .JiraURL) as? String else {
                return nil
            }

            return value
    }

    //MARK: Stored using NSUserDefaults
    var refresh: RefreshType {
        get {
            guard let value = RefreshType(rawValue: self.defaults.doubleForKey(PreferenceType.Refresh.rawValue)) else {
                return .Ten
            }

            return value
        }
        set {
            self.defaults.setDouble(newValue.rawValue, forKey: PreferenceType.Refresh.rawValue)
        }
    }

    var title: String {
        get {
            guard let string = self.defaults.objectForKey(PreferenceType.Title.rawValue) as? String else {
                return "Issues"
            }

            return string
        }
        set {
            self.defaults.setObject(newValue, forKey: PreferenceType.Title.rawValue)
        }
    }


    //MARK: Properties
    static let sharedInstance = Preferences()
    private let userAccount = "dk.pisarm.gojira-watch.preferences"
    private var preferenceData: [String : AnyObject] = [:]
    private let defaults = NSUserDefaults.standardUserDefaults()

    //MARK: Set and get
    func setPreference(value: AnyObject?, forKey key: ContextType) {
        guard let value = value else {
            return
        }

        preferenceData[key.rawValue] = value

        do {
            try Locksmith.updateData(preferenceData, forUserAccount: userAccount)
        } catch { print(error) }
    }

    private func preference(forKey key: ContextType) -> AnyObject? {
        guard let preference = preferenceData[key.rawValue] else {
            return nil
        }
        
        return preference
    }
}
