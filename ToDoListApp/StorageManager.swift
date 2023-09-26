//
//  StorageManager.swift
//  ToDoListApp
//
//  Created by Екатерина Теляубердина on 26.09.2023.
//

import Foundation
import CoreData

final class StorageManager {
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ToDoListApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
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
    
    // MARK: - Public Methods
    func fetchData() {
        let fetchRequest = ToDoTask.fetchRequest()
        
        do {
            let taskList = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func save(taskName: String, completion: @escaping(ToDoTask) -> Void){
        let task = ToDoTask(context: persistentContainer.viewContext)
        task.title = taskName
        completion(task)
        saveContext()
    }
    
    func editing(task: ToDoTask, newName: String) {
        task.title = newName
        saveContext()
    }
    
    func deleteContact(task: ToDoTask) {
        persistentContainer.viewContext.delete(task)
        saveContext()
    }
    
    private init() {}
}
