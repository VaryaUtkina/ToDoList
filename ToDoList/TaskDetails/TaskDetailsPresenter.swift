//
//  TaskDetailsPresenter.swift
//  ToDoList
//
//  Created by Варвара Уткина on 22.11.2024.
//

import Foundation

struct TaskDetailsDataStore {
    let title: String?
    let description: String?
    let date: Date
}

final class TaskDetailsPresenter: TaskDetailsViewOutputProtocol {

    var interactor: TaskDetailsInteractorInputProtocol!
    private unowned let view: TaskDetailsViewInputProtocol
    
    required init(view: any TaskDetailsViewInputProtocol) {
        self.view = view
    }
    
    func showTask() {
        interactor.provideTaskDetails()
    }
    
    func doneButtonTapped(withTitle title: String?, andDescription description: String?) {
        interactor.provideSavingTask(withTitle: title, andDescription: description)
    }
}


// MARK: - TaskDetailsInteractorOutputProtocol
extension TaskDetailsPresenter: TaskDetailsInteractorOutputProtocol {
    func receiveTaskDetails(with dataStore: TaskDetailsDataStore) {
        let date = formattedDate(dataStore.date)
        
        view.displayTaskTitle(dataStore.title)
        view.displayTaskDescription(dataStore.description)
        view.displayTaskDate(date)
    }
    
    func receiveSavingTask(withAlert alert: Bool) {
        view.doneButtonTapped(withAlert: alert)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: date)
    }
}
