//
//  PreferencesService.swift
//  Gojira
//
//  Created by Flemming Pedersen on 29/10/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//

import Foundation

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

enum PreferencesType: String {
    case Query
    case Refresh
    case Title
}

final class Preferences {
    var query: String? {
        get {
            return "issuetype = Bug AND status not in (Closed, Resolved, Impeeded) AND labels = iOS AND Product != mPOS ORDER BY priority, createdDate DESC"
//            guard let string = self.defaults.objectForKey(PreferencesType.Query.rawValue) as? String else {
//                return nil
//            }
//
//            return string
        }
        set {
            self.defaults.setObject(newValue, forKey: PreferencesType.Query.rawValue)
        }
    }

    var refresh: RefreshType {
        get {
            guard let value = RefreshType(rawValue: self.defaults.doubleForKey(PreferencesType.Refresh.rawValue)) else {
                return .Ten
            }

            return value
        }
        set {
            self.defaults.setDouble(newValue.rawValue, forKey: PreferencesType.Refresh.rawValue)
        }
    }

    var title: String {
        get {
            guard let string = self.defaults.objectForKey(PreferencesType.Title.rawValue) as? String else {
                return "Issues"
            }

            return string
        }
        set {
            self.defaults.setObject(newValue, forKey: PreferencesType.Title.rawValue)
        }
    }

    private let defaults = NSUserDefaults.standardUserDefaults()
}
