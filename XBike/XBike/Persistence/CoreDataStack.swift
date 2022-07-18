//
//  CoreDataStack.swift
//  XBike
//
//  Created by Leandro.Demarco on 14/07/2022.
//

import CoreData

class CoreDataStack {
    private let modelName: String
    private lazy var managedContext: NSManagedObjectContext = {
        storeContainer.viewContext
    }()

    init(modelName: String) {
        self.modelName = modelName
    }

    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Unresolved error while creating container \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    func saveContext() throws {
        guard managedContext.hasChanges else { return }
        try managedContext.save()
    }

    func performFetchRequest<T: NSManagedObject>(_ fetchRequest: NSFetchRequest<T>) throws -> [T] {
        let result = try managedContext.fetch(fetchRequest)
        return result
    }

    func createNewEntity<T: NSManagedObject>(ofType: T.Type) -> T {
        let newEntity = T(context: managedContext)
        return newEntity
    }

    func removeEntity<T: NSManagedObject>(_ entity: T) throws {
        managedContext.delete(entity)
        try managedContext.save()
    }
}
