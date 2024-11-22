//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by Варвара Уткина on 22.11.2024.
//

import Foundation

protocol TaskListRouterInputProtocol {
    init(view: TaskListViewController)
    func openTaskDetailsViewController(with task: ToDoTask)
}

final class TaskListRouter: TaskListRouterInputProtocol {
    private unowned let view: TaskListViewController
    
    required init(view: TaskListViewController) {
        self.view = view
    }
    
    func openTaskDetailsViewController(with task: ToDoTask) {
        
    }
}
