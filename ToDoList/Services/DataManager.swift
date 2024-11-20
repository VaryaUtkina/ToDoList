//
//  DataManager.swift
//  ToDoList
//
//  Created by Варвара Уткина on 20.11.2024.
//

import Foundation


final class DataManager {
    
    static let shared = DataManager()
    
    private let networkManager = NetworkManager.shared
    private let storageManager = StorageManager.shared
    
    private init() {}
    
    func createTempData(completion: @escaping() -> Void) {
        networkManager.fetchTasks(withURL: URL(string: "https://dummyjson.com/todos")) { [unowned self] result in
            switch result {
            case .success(let tasks):
                storageManager.save(tasks)
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
}
