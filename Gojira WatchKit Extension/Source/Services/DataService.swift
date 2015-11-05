//
//  DataService.swift
//  Gojira
//
//  Created by Flemming Pedersen on 29/10/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//

import Foundation
import WatchKit

protocol DataServiceDelegate {
    func dataUpdated<T>(type: DataType, value: T)
}

enum Minutes: Double {
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

enum DataType: String {
    case Query
    case Refresh
    case Title
    case Total
}

final class DataService {
    var query: String? {
        get {
            guard let string = self.defaults.objectForKey(DataType.Query.rawValue) as? String else {
                return nil
            }

            return string
        }
        set {
            self.defaults.setObject(newValue, forKey: DataType.Query.rawValue)
            if let value = newValue {
                self.notifyDelegates(.Query, value: value)
            }
        }
    }

    var refresh: Minutes {
        get {
            guard let value = Minutes(rawValue: self.defaults.doubleForKey(DataType.Refresh.rawValue)) else {
                return .Ten
            }

            return value
        }
        set {
            self.defaults.setDouble(newValue.rawValue, forKey: DataType.Refresh.rawValue)
            self.notifyDelegates(.Refresh, value: newValue)
        }
    }

    var title: String? {
        get {
            guard let string = self.defaults.objectForKey(DataType.Title.rawValue) as? String else {
                return nil
            }

            return string
        }
        set {
            self.defaults.setObject(newValue, forKey: DataType.Title.rawValue)
            if let value = newValue {
                self.notifyDelegates(.Title, value: value)
            }
        }
    }

    var total: Int? {
        get {
            guard let value = self.defaults.objectForKey(DataType.Total.rawValue) as? Int else {
                return nil
            }

            return value
        }
        set {
            self.defaults.setObject(newValue, forKey: DataType.Total.rawValue)
            if let value = newValue {
                self.notifyDelegates(.Total, value: value)
            }
        }
    }

    static let sharedInstance = DataService()
    private let defaults = NSUserDefaults.standardUserDefaults()
    private var delegates = [DataServiceDelegate]()

    //MARK: Setter used by WatchService

    func set(keyValue: [String : AnyObject]) {
        keyValue.forEach { set($0.1, forKey: $0.0) }
    }

    private func set(value: AnyObject, forKey key: String) {
        guard let type = DataType(rawValue: key) else {
            return
        }

        set(value, type: type)
    }

    private func set(value: AnyObject, type: DataType) {
        switch type {
        case .Query:
            guard let value = value as? String else {
                return
            }
            query = value
        case .Refresh:
            break
        case .Title:
            guard let value = value as? String else {
                return
            }
            title = value
        case .Total:
            break
        }
    }

    //MARK: Delegate handling

    private func notifyDelegates<T>(type: DataType, value: T) {
        dispatch_async(dispatch_get_main_queue()) {
            self.delegates.forEach { $0.dataUpdated(type, value: value) }
        }
    }

    func addDelegate<T where T: DataServiceDelegate, T: Equatable>(delegate: T) {
        delegates.append(delegate)
    }

    func removeDelegate<T where T: DataServiceDelegate, T: Equatable>(delegate: T) {
        for (index, indexDelegate) in delegates.enumerate() {
            if let indexDelegate = indexDelegate as? T where indexDelegate == delegate {
                delegates.removeAtIndex(index)
                break
            }
        }
    }
}