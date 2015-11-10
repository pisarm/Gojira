//
//  Fetchable.swift
//  Gojira
//
//  Created by Flemming Pedersen on 06/11/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//

import CoreData
import Foundation

protocol Fetchable {
    static func entityName() -> String
    init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?)
}

extension NSManagedObject: Fetchable {}

extension Fetchable where Self: NSManagedObject {
    init(managedObjectContext: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName(Self.entityName(), inManagedObjectContext: managedObjectContext)!
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    static func entityName() -> String {
        let fullClassName = NSStringFromClass(self)
        return fullClassName.componentsSeparatedByString(".").last!
    }

    static func fetch(context: NSManagedObjectContext) throws -> Array<Self> {
        return try self.fetchUsingPredicate(nil, sortDescriptors: nil, context: context)
    }

    static func fetchUsingPredicate(predicate: NSPredicate?, context: NSManagedObjectContext) throws -> Array<Self> {
        return try self.fetchUsingPredicate(predicate, sortDescriptors: nil, context: context)
    }

    static func fetchUsingPredicate(predicate: NSPredicate?, sortDescriptors:[NSSortDescriptor]?, context: NSManagedObjectContext) throws -> Array<Self> {
        let request = NSFetchRequest(entityName: entityName())
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        return try context.executeFetchRequest(request) as! Array<Self>
    }

    static func fetchCount(context: NSManagedObjectContext) throws -> Int {
        return try self.fetchCountUsingPredicate(nil, context: context)
    }

    static func fetchCountUsingPredicate(predicate: NSPredicate?, context: NSManagedObjectContext) throws -> Int {
        let request = NSFetchRequest(entityName: entityName())
        request.predicate = predicate
        var error: NSError?
        let count = context.countForFetchRequest(request, error: &error)
        if let error = error {
            throw error
        }
        return count
    }
}
