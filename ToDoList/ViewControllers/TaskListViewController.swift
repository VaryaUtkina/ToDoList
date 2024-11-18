//
//  ViewController.swift
//  ToDoList
//
//  Created by Варвара Уткина on 18.11.2024.
//

import UIKit

final class TaskListViewController: UIViewController {
    
    @IBOutlet var tasksTableView: UITableView!
    
    private var tasks: [Task] = []
    private let networkManager = NetworkManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        tasksTableView.dataSource = self
        fetchTasks()
    }
    
    private func fetchTasks() {
        networkManager.fetchTasks(withURL: URL(string: "https://dummyjson.com/todos")) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let tasks):
                self.tasks = tasks
                tasksTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

 // MARK: - UITableViewDataSource
extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        guard let cell = cell as? TaskTableViewCell else { return UITableViewCell() }
        let task = tasks[indexPath.row]
        cell.configure(withTask: task)
        return cell
    }
}

