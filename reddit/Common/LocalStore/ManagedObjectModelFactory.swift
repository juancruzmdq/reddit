//
//  ManagedObjectModelFactory.swift
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation
import CoreData

/// Protocol to be implemented by a class that can be a result of the ManagedObjectModelFactory
protocol ManagedObjectModel: NSFetchRequestResult { }

/// Protocol to be implemented by a class that will works as a ManagedObjectModel factory
protocol ManagedObjectModelFactory {

    /// ManagedObjectModelFactory result's type
    associatedtype ManagedObjectModelType: ManagedObjectModel

    /// Name of the attibute used as primary key of the model
    static var KeyAttributeName: String { get set }

    /// return the first instance with a given id
    ///
    /// - Parameters:
    ///   - context: coredata context to search the instance
    ///   - uid: id of the instance
    /// - Returns: An instance of a ManagedObjectModelType with the given id
    static func object(in context: NSManagedObjectContext, with uid: String) -> ManagedObjectModelType?

    /// Return all NSManagedObject that fullfil the specified predicate
    ///
    /// - Parameters:
    ///   - context: coredata context to do the search
    ///   - predicate: predicate used for the query
    ///   - entityName: entityname of the searched instances
    /// - Returns: A list of ManagedObjectModelType
    static func objects(in context: NSManagedObjectContext, withPredicate predicate: NSPredicate?) -> [ManagedObjectModelType]

    /// Create a new instance of an object of the declared generyc type
    ///
    /// - Parameter context: coredata context to create the instance
    /// - Returns: An instance of a ManagedObjectModelType
    static func create(in context: NSManagedObjectContext) -> ManagedObjectModelType?

    /// Look up for a object with the specified uid, if not exist create it.
    ///
    /// - Parameters:
    ///   - context: coredata context to search the instance
    ///   - uid: id of the instance
    /// - Returns: An instance of a ManagedObjectModelType with the given id
    static func getOrCreateObject(in context: NSManagedObjectContext, with uid: String) -> ManagedObjectModelType?

    /// Create and returns a NSFetchedResultsController for all objects of the type ManagedObjectModelType
    ///
    /// - Parameters:
    ///   - context: coredata context to do the search
    ///   - sortBy: Sorting descriptos [NSSortDescriptor]
    /// - Returns: A NSFetchedResultsController for objects of the type ManagedObjectModelType
    static func fetchResultsController(in context: NSManagedObjectContext, sortBy: [NSSortDescriptor] ) -> NSFetchedResultsController<ManagedObjectModelType>?

}

extension ManagedObjectModelFactory where ManagedObjectModelType: NSManagedObject {

    static func object(in context: NSManagedObjectContext, with uid: String) -> ManagedObjectModelType? {
        let predicate = NSPredicate(format: "\(Self.KeyAttributeName) == %@", uid)
        return self.objects(in: context, withPredicate: predicate).first
    }

    static func objects(in context: NSManagedObjectContext, withPredicate predicate: NSPredicate? = nil) -> [ManagedObjectModelType] {
        let entityNameForRequest = NSStringFromClass(ManagedObjectModelType.self)

        let fetchRequest = NSFetchRequest<ManagedObjectModelType>(entityName: entityNameForRequest)
        fetchRequest.predicate = predicate

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Unable fetch objects of type: \(entityNameForRequest) with predicate: \(String(describing: predicate)). Error: \(error)")
            return []
        }
    }

    static func create(in context: NSManagedObjectContext) -> ManagedObjectModelType? {
        return NSEntityDescription.insertNewObject(forEntityName: NSStringFromClass(ManagedObjectModelType.self), into: context) as? ManagedObjectModelType
    }

    static func getOrCreateObject(in context: NSManagedObjectContext, with uid: String) -> ManagedObjectModelType? {

        if let managedObject = Self.object(in: context, with: uid) {
            return managedObject
        }
        // If didn't found it then create it
        return Self.create(in: context)

    }

    static func fetchResultsController(in context: NSManagedObjectContext, sortBy: [NSSortDescriptor] = []) -> NSFetchedResultsController<ManagedObjectModelType>? {

        guard let fetchRequest = ManagedObjectModelType.fetchRequest() as? NSFetchRequest<ManagedObjectModelType> else { return nil }
        fetchRequest.sortDescriptors = sortBy

        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                managedObjectContext: context,
                                                                sectionNameKeyPath: nil,
                                                                cacheName: nil)

        return fetchResultsController
    }

}
