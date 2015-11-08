//
//  DataFacade.swift
//  Gojira
//
//  Created by Flemming Pedersen on 05/11/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//


import Foundation

final class DataFacade {
    static let sharedInstance = DataFacade()

    private let stack = CoreDataStack()
    private let jira = JiraService()
    private let preferences = Preferences()

    var query: String? {
        get {
            return preferences.query
        }
        set {
            preferences.query = newValue
        }
    }
    var refresh: RefreshType {
        get {
            return preferences.refresh
        }
        set {
            preferences.refresh = newValue
        }
    }
    var title: String {
        get {
            return preferences.title
        }
        set {
            preferences.title = newValue
        }
    }

    //MARK: TotalData

    func refreshTotal(completion: (totalData: TotalData?) -> Void) {
        jira.refreshTotal(preferences.query) { total in
            guard let total = total else {
                completion(totalData: nil)
                return
            }

            dispatch_async(dispatch_get_main_queue()) {
                let oldTotalData = self.newestTotalData()

                let totalData = TotalData(managedObjectContext: self.stack.context)
                totalData.total = Int16(total)
                totalData.created = NSDate().timeIntervalSince1970

                if let oldTotalData = oldTotalData {
                    totalData.oldTotal = oldTotalData.total
                }
                self.stack.saveContext()

                completion(totalData: totalData)
            }
        }
    }

    func newestTotalData() -> TotalData? {
        guard let maybeNewestTotalData = try? TotalData.newest(self.stack.context), newestTotalData = maybeNewestTotalData else {
            return nil
        }

        return newestTotalData
    }

    func allTotalData() -> [TotalData]? {
        guard let allTotalData = try? TotalData.fetchUsingPredicate(nil, sortDescriptors: [NSSortDescriptor(key: "", ascending: true)], context: self.stack.context) else {
            return nil
        }

        return allTotalData
    }

    func countTotalData() -> Int {
        guard let count = try? TotalData.fetchCount(self.stack.context) else {
            return 0
        }

        return count
    }
}
