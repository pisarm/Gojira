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
        guard let
            _ = Preferences.sharedInstance.username,
            _ = Preferences.sharedInstance.password,
            _ = Preferences.sharedInstance.jiraURL
            else {
                return false
        }

        return true
    }

    //MARK: Preferences
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

    var filterId: String? {
        get {
            return preferences.filterId
        }
        set {
            preferences.filterId = newValue
        }
    }

    static let sharedInstance = DataFacade()

    private let stack = CoreDataStack()
    private let jira = Jira()
    private let preferences = Preferences()
}

//MARK: Fetching FilterData
extension DataFacade {
    func fetchFilterData() -> [FilterData] {
        guard let filterData = try? FilterData.fetch(self.stack.context) else {
            return []
        }

        return filterData
    }

    func fetchFilterData(filterId: String) -> FilterData? {

        return nil
    }
}

//MARK: Fetching TotalData
extension DataFacade {
    func fetchNewestTotalData() -> TotalData? {
        guard let maybeNewestTotalData = try? TotalData.fetchNewest(self.stack.context), newestTotalData = maybeNewestTotalData else {
            return nil
        }

        return newestTotalData
    }

    func fetchTotalData() -> [TotalData]? {
        guard let allTotalData = try? TotalData.fetchUsingPredicate(nil, sortDescriptors: [NSSortDescriptor(key: "", ascending: true)], context: self.stack.context) else {
            return nil
        }

        return allTotalData
    }

    func fetchTotalDataCount() -> Int {
        guard let count = try? TotalData.fetchCount(self.stack.context) else {
            return 0
        }

        return count
    }
}

//MARK: Refreshing data
extension DataFacade {
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

    func refreshTotalData(completion: (totalData: TotalData?) -> Void) {
        guard let
            jiraURL = preferences.jiraURL,
            username = preferences.username,
            password = preferences.password,
            filterId = preferences.filterId
            else {
                completion(totalData: nil)
                return
        }

        let basicAuth = BasicAuth(username: username, password: password)
        guard let
            maybeFilterData = try? FilterData.fetch(filterId, context: self.stack.context),
            filterData = maybeFilterData
            else {
                completion(totalData: nil)
                return
        }

        jira.fetchTotalData(filterData.jql, baseURL: jiraURL, basicAuth: basicAuth) { data in
            dispatch_async(dispatch_get_main_queue()) {
                guard let data = data else {
                    completion(totalData: nil)
                    return
                }

                let json = JSON(data: data)
                let maybeTotalData = TotalData.from(json, context: self.stack.context)

                guard let totalData = maybeTotalData else {
                    completion(totalData: nil)
                    return
                }
                
                self.stack.saveContext()
                
                completion(totalData: totalData)
            }
        }
    }
}
