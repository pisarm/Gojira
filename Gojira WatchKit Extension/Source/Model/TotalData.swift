//
//  TotalData.swift
//  Gojira
//
//  Created by Flemming Pedersen on 06/11/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//

import CoreData
import Foundation
import SwiftyJSON

private enum JSONKey: String {
    case Total = "total"
}

@objc(TotalData)
class TotalData: NSManagedObject {
    static func from(json: JSON, context: NSManagedObjectContext) -> TotalData? {
        guard let
            total = json[JSONKey.Total.rawValue].int
            else {
                return nil
        }

        var oldTotalData: TotalData?
        do {
            oldTotalData = try TotalData.fetchNewest(context)
        } catch {
            print(error)
        }

        let totalData = TotalData(managedObjectContext: context)
        totalData.total = Int16(total)
        totalData.created = NSDate().timeIntervalSince1970

        if let oldTotalData = oldTotalData {
            totalData.oldTotal = oldTotalData.total
        }

        return totalData
    }

    static func fetchNewest(context: NSManagedObjectContext) throws -> TotalData? {
        return try fetchUsingPredicate(nil, sortDescriptors: [NSSortDescriptor(key: "created", ascending: false)], context: context).first
    }

    static func deleteOldest(context: NSManagedObjectContext) throws {
        
    }
}
