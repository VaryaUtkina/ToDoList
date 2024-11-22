//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by Варвара Уткина on 22.11.2024.
//

import Foundation

struct TaskListDataStore {
    let tasks: [ToDoTask]
}

final class TaskListPresenter: TaskListViewOutputProtocol {
    var interactor: TaskListInteractorInputProtocol!
    var router: TaskListRouterInputProtocol!
    
    unowned private let view: TaskListViewInputProtocol
    private var dataStore: TaskListDataStore?
    
    required init(view: any TaskListViewInputProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        
    }
}

// MARK: - TaskListInteractorOutputProtocol
extension TaskListPresenter: TaskListInteractorOutputProtocol {
    func tasksWereReceived(with dataStore: TaskListDataStore) {
        self.dataStore = dataStore
        view.display(tasks: dataStore.tasks)
    }
    
    
}
