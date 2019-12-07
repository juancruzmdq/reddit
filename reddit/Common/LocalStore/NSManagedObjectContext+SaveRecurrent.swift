//
//  NSManagedObjectContext+SaveRecurrent.swift
//
//  Created by Juan Cruz Ghigliani on 15/5/18.
//

import Foundation
import CoreData

extension NSManagedObjectContext {

    func recurrentSaveContext() {
        NSManagedObjectContext.recurrentSaveContext(self)
    }

    static func recurrentSaveContext(_ context: NSManagedObjectContext) {
        context.perform {
            do {
                try context.save()
            } catch {
                print("Unable to save [\(context.debugDescription)] context. Error: \(error)")
                return
            }

            if let parentContext = context.parent {
                NSManagedObjectContext.recurrentSaveContext(parentContext)
            }
        }
    }

    func childContext(concurrencyType: NSManagedObjectContextConcurrencyType = .privateQueueConcurrencyType) -> NSManagedObjectContext {
        let childContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        childContext.parent = self
        return childContext

    }
}
