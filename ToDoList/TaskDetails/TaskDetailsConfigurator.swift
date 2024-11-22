//
//  TaskDetailsConfigurator.swift
//  ToDoList
//
//  Created by Варвара Уткина on 22.11.2024.
//

import Foundation

protocol TaskDetailsConfiguratorInputProtocol {
    func configure(with view: TaskDetailsViewController, and task: ToDoTask?)
}

final class TaskDetailsConfigurator: TaskDetailsConfiguratorInputProtocol {
    func configure(with view: TaskDetailsViewController, and task: ToDoTask?) {
        let presenter = TaskDetailsPresenter(view: view)
        let interactor = TaskDetailsInteractor(presenter: presenter, task: task)
        view.presenter = presenter
        presenter.interactor = interactor
    }
}
