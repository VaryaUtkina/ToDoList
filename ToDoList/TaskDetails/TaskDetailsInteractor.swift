//
//  TaskDetailsInteractor.swift
//  ToDoList
//
//  Created by Варвара Уткина on 22.11.2024.
//

import Foundation

protocol TaskDetailsInteractorInputProtocol {
    init(presenter: TaskDetailsInteractorOutputProtocol, task: ToDoTask?)
    func provideTaskDetails()
    func provideSavingTask(withTitle title: String?, andDescription description: String?)
}

protocol TaskDetailsInteractorOutputProtocol: AnyObject {
    func receiveTaskDetails(with dataStore: TaskDetailsDataStore)
    func receiveSavingTask(withAlert alert: Bool)
}

final class TaskDetailsInteractor: TaskDetailsInteractorInputProtocol {
    
    private unowned let presenter: TaskDetailsInteractorOutputProtocol
    private let task: ToDoTask?
    private let storageManager = StorageManager.shared
    
    init(presenter: any TaskDetailsInteractorOutputProtocol, task: ToDoTask?) {
        self.presenter = presenter
        self.task = task
    }
    
    func provideTaskDetails() {
        let dataStore = TaskDetailsDataStore(
            title: task?.title,
            description: task?.taskDescription,
            date: task?.date ?? Date()
        )
        presenter.receiveTaskDetails(with: dataStore)
    }
    
    func provideSavingTask(withTitle title: String?, andDescription description: String?) {
        guard let title, !title.isEmpty else {
            presenter.receiveSavingTask(withAlert: true)
            return
        }
        if let task {
            storageManager.update(
                task,
                withNewTitle: title,
                AndNewDescription: description
            )
        } else {
            storageManager.create(title, description)
        }
        presenter.receiveSavingTask(withAlert: false)
    }
}
