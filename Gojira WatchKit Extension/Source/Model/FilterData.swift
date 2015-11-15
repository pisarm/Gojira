//
//  FilterData.swift
//  Gojira
//
//  Created by Flemming Pedersen on 10/11/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

private enum JSONKey: String {
    case Id = "id"
    case Name = "name"
    case JQL = "jql"
}

@objc(FilterData)
class FilterData: NSManagedObject {
    static func from(json: JSON, context: NSManagedObjectContext) -> FilterData? {
        guard let
            id = json[JSONKey.Id.rawValue].string,
            name = json[JSONKey.Name.rawValue].string,
            jql = json[JSONKey.JQL.rawValue].string
            else {
                return nil
        }

        let filterData = FilterData(managedObjectContext: context)
        filterData.id = id
        filterData.name = name
        filterData.jql = jql

        return filterData
    }

    static func fetch(filterId: String, context: NSManagedObjectContext) throws -> FilterData? {
        return try FilterData.fetchUsingPredicate(NSPredicate(format: "%K == %@", "id", filterId), context: context).first
    }
}

//MARK: Comparable
extension FilterData: Comparable {}

func < (lhs: FilterData, rhs: FilterData) -> Bool {
    return lhs.name < rhs.name
}

func == (lhs: FilterData, rhs: FilterData) -> Bool {
    return lhs.name == rhs.name
}
