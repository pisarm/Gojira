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
    func fetchFilterData(completion: () -> Void) {
        guard let
            jiraURL = preferences.jiraURL,
            username = preferences.username,
            password = preferences.password
            else {
                completion()
                return
        }

        let basicAuth = BasicAuth(username: username, password: password)

        jira.fetchFilterData(jiraURL, basicAuth: basicAuth) {
            guard let data = $0 else {
                return
            }

            let json = JSON(data: data)

            for (_, subJSON) : (String, JSON) in json {
                FilterData.from(subJSON, context: self.stack.context)
            }
            self.stack.saveContext()

            //TODO: Return filterData array or signal done??

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
