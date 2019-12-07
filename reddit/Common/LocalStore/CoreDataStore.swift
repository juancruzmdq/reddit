//
//  CoreDataStore.swift
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import UIKit
import CoreData

enum PersistentStoreTypes {
    case SQLiteStoreType
    case binaryStoreType
    case inMemoryStoreType
}

/// Protocol to be implemented by the CoreDataStoreConfig provider
protocol CoreDataStoreConfigProtocol {
    var persistenContainerName: String { get }
    var persistentStoreTypes: PersistentStoreTypes { get }
}

/// Class to manage a core data stack
class CoreDataStore {
    let persistenContainerName: String
    let persistentStoreTypes: PersistentStoreTypes

    init(config: CoreDataStoreConfigProtocol) {
        self.persistenContainerName = config.persistenContainerName
        self.persistentStoreTypes = config.persistentStoreTypes
    }

    var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
        return self.persistentContainer.persistentStoreCoordinator
    }

    var managedObjectModel: NSManagedObjectModel? {
        return self.persistentContainer.managedObjectModel
    }

    var viewContext: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.persistenContainerName)

        if self.persistentStoreTypes == .inMemoryStoreType {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
