//
//  DataService.swift
//  Gojira
//
//  Created by Flemming Pedersen on 24/10/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//

import Bond
import Foundation

private enum DataType: String{
    case LastRefresh
    case Query
    case Title
    case Total
}

final class DataService {
    lazy var observableLastRefresh: Observable<NSDate?> = {
        guard let date = self.defaults.objectForKey(DataType.LastRefresh.rawValue) as? NSDate else {
            return Observable(nil)
        }
        return Observable(date)
    }()

    lazy var observableQuery: Observable<String?> = {
        guard let string = self.defaults.objectForKey(DataType.Query.rawValue) as? String else {
            return Observable("")
        }

        return Observable(string)
    }()

    lazy var observableTitle: Observable<String?> = {
        guard let string = self.defaults.objectForKey(DataType.Title.rawValue) as? String else {
            return Observable("")
        }

        return Observable(string)
    }()

    lazy var observableTotal: Observable<Int?> = {
        guard let value = self.defaults.objectForKey(DataType.Total.rawValue) as? Int else {
            return Observable(nil)
        }

        return Observable(value)
    }()

    static let sharedInstance = DataService()
    private let defaults = NSUserDefaults.standardUserDefaults()

    init() {
        setupBonds()
    }

    private func setupBonds() {
        observableLastRefresh.observeNew { self.defaults.setObject($0, forKey: DataType.LastRefresh.rawValue) }
        observableQuery.observeNew { self.defaults.setObject($0, forKey: DataType.Query.rawValue) }
        observableTitle.observeNew { self.defaults.setObject($0, forKey: DataType.Title.rawValue) }
        observableTotal.observeNew { self.defaults.setObject($0, forKey: DataType.Total.rawValue) }
    }
}
