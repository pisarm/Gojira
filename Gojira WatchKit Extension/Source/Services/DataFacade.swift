//
//  DataFacade.swift
//  Gojira
//
//  Created by Flemming Pedersen on 05/11/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//

import Foundation
import SwiftyJSON

final class DataFacade {
    var initialized: Bool {
        guard let _ = Preferences.sharedInstance.username, _ = Preferences.sharedInstance.password, _ = Preferences.sharedInstance.jiraURL else {
            return false
        }

        return true
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

    static let sharedInstance = DataFacade()

    private let stack = CoreDataStack()
    private let jira = Jira()
    private let preferences = Preferences()

    //MARK: FilterData
    func fetchFilterData() -> [FilterData] {
        guard let filterData = try? FilterData.fetchUsingPredicate(nil, sortDescriptors: nil, context: self.stack.context) else {
            return []
        }

        return filterData
    }

    func refreshFilterData(completion: (filterData: [FilterData]) -> Void) {
        guard let
            jiraURL = preferences.jiraURL,
            username = preferences.username,
            password = preferences.password
            else {
                completion(filterData: [])
                return
        }

        let basicAuth = BasicAuth(username: username, password: password)

        jira.fetchFilterData(jiraURL, basicAuth: basicAuth) { data in
            dispatch_async(dispatch_get_main_queue()) {
                guard let data = data else {
                    completion(filterData: [])
                    return
                }

                do {
                    try FilterData.delete(self.stack.context)
                } catch {
                    print(error)
                }

                let json = JSON(data: data)
                for (_, subJSON) : (String, JSON) in json {
                    FilterData.from(subJSON, context: self.stack.context)
                }
                self.stack.saveContext()

                completion(filterData: self.fetchFilterData())
            }
        }
    }

    //MARK: TotalData


    func fetchTotal(completion: (totalData: TotalData?) -> Void) {

        //        jira.refreshTotal(preferences.query) { total in
        //            guard let total = total else {
        //                completion(totalData: nil)
        //                return
        //            }
        //
        //            dispatch_async(dispatch_get_main_queue()) {
        //                let oldTotalData = self.newestTotalData()
        //
        //                let totalData = TotalData(managedObjectContext: self.stack.context)
        //                totalData.total = Int16(total)
        //                totalData.created = NSDate().timeIntervalSince1970
        //
        //                if let oldTotalData = oldTotalData {
        //                    totalData.oldTotal = oldTotalData.total
        //                }
        //                self.stack.saveContext()
        //
        //                completion(totalData: totalData)
        //            }
        //        }
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
