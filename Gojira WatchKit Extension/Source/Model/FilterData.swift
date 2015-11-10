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
    case Name = "name"
    case JQL = "jql"
}

@objc(FilterData)
class FilterData: NSManagedObject {
    static func from(json: JSON, context: NSManagedObjectContext) -> FilterData? {
        guard let
            name = json[JSONKey.Name.rawValue].string,
            jql = json[JSONKey.JQL.rawValue].string
            else {
                return nil
        }

        let filterData = FilterData(managedObjectContext: context)
        filterData.name = name
        filterData.jql = jql

        return filterData
    }
}
