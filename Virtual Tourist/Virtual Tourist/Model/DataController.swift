//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Eduardo Ramos on 26/06/21.
//

import Foundation
import CoreData

class DataController {
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Virtual_Tourist")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
    
    func load(completion: (() -> Void)? = nil){
        persistentContainer.loadPersistentStores { (store, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSave()
            self.configureContexts()
            completion?()
        }
    }
    
    func save () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    func fetchAllPins() throws -> [Pin]? {
        let fetchPins = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        guard let pin = try viewContext.fetch(fetchPins) as? [Pin] else {
            return nil
        }
        return pin
    }
    
    func fetchAllPhotos() throws -> [Photo]? {
        let fecthPhotos = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        guard let photo = try viewContext.fetch(fecthPhotos) as? [Photo] else {
            return nil
        }
        return photo
    }
}

extension DataController {
    func autoSave(interval: TimeInterval = 30){
        print("autosaving...")
        
        guard interval > 0 else {
            print("The interval for auto save cannot be negative")
            return
        }
        
        self.save()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSave(interval: interval)
        }
    }
}
 
