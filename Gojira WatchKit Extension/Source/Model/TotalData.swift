//
//  TotalData.swift
//  Gojira
//
//  Created by Flemming Pedersen on 06/11/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//

import Foundation
import CoreData

@objc(TotalData)
class TotalData: NSManagedObject {
    static func newest(context: NSManagedObjectContext) throws -> TotalData? {
         return try fetchUsingPredicate(nil, sortDescriptors: [NSSortDescriptor(key: "created", ascending: false)], context: context).first
    }
}
