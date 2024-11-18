//
//  ViewController.swift
//  ToDoList
//
//  Created by Варвара Уткина on 18.11.2024.
//

import UIKit

final class TaskListViewController: UIViewController {
    
    private var tasks: [Task] = []
    private let networkManager = NetworkManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTasks()
    }
    
    private func fetchTasks() {
        networkManager.fetchTasks(withURL: URL(string: "https://dummyjson.com/todos")) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let tasks):
                self.tasks = tasks
            case .failure(let error):
                print(error)
            }
        }
    }


}

