//
//  TotalData+CoreDataProperties.swift
//  Gojira
//
//  Created by Flemming Pedersen on 06/11/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TotalData {
    @NSManaged var created: NSTimeInterval
    @NSManaged var oldTotal: Int16
    @NSManaged var total: Int16
}
