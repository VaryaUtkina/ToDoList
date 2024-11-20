//
//  StorageManager.swift
//  ToDoList
//
//  Created by Варвара Уткина on 20.11.2024.
//

import CoreData

final class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    private let viewContext: NSManagedObjectContext

    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - CRUD
    func create(_ taskTitle: String, _ taskDescription: String?, completion: (ToDoTask) -> Void) {
        let task = ToDoTask(context: viewContext)
        task.title = taskTitle
        task.taskDescription = taskDescription
        task.date = Date()
        task.isCompleted = false
        completion(task)
        saveContext()
    }
    
    func fetchData(completion: @escaping(Result<[ToDoTask], Error>) -> Void) {
        let fetchRequest = ToDoTask.fetchRequest()
        
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            DispatchQueue.main.async {
                completion(.success(tasks))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
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
}
