//
//  CoreDataStack.swift
//  Gojira
//
//  Created by Flemming Pedersen on 06/11/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//

import CoreData
import Foundation

final class CoreDataStack {
    let modelName = "Model"

    lazy var context: NSManagedObjectContext = {
        var moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        return moc
    }()

    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let psc = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.modelName)
        let options = [NSMigratePersistentStoresAutomaticallyOption : true]

        do {
            try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
        } catch {
            print(error)
        }

        return psc
    }()

    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource(self.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print("\(error.localizedDescription)")
                abort()
            }
        }
    }
}
