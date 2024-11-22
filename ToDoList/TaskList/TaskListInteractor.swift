//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by Варвара Уткина on 22.11.2024.
//

import Foundation

protocol TaskListInteractorInputProtocol {
    init(presenter: TaskListInteractorOutputProtocol)
    func fetchTasks()
}

protocol TaskListInteractorOutputProtocol: AnyObject {
    func tasksWereReceived(with dataStore: TaskListDataStore)
}

final class TaskListInteractor: TaskListInteractorInputProtocol {
    unowned private let presenter: TaskListInteractorOutputProtocol
    
    init(presenter: any TaskListInteractorOutputProtocol) {
        self.presenter = presenter
    }
    
    func fetchTasks() {
        StorageManager.shared.fetchData { [unowned self] result in
            switch result {
            case .success(let tasks):
                let dataStore = TaskListDataStore(tasks: tasks)
                presenter.tasksWereReceived(with: dataStore)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
