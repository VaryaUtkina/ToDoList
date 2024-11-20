//
//  ViewController.swift
//  ToDoList
//
//  Created by Варвара Уткина on 18.11.2024.
//

import UIKit

protocol TaskDetailsViewControllerDelegate: AnyObject {
    func reloadData()
}

final class TaskListViewController: UIViewController {
    
    @IBOutlet var tasksTableView: UITableView!
    @IBOutlet var tasksCountLabel: UILabel!
    
    private var tasks: [Task] = []
    private var taskList: [ToDoTask] = [] {
        didSet {
            updateTasksCountLabel()
        }
    }
    private let networkManager = NetworkManager.shared
    private let storageManager = StorageManager.shared
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredTasks: [Task] = []
    private var selectedIndexPath: IndexPath?
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tasksTableView.dataSource = self
        tasksTableView.delegate = self
        
        setupSearchController()
        fetchData()
//        fetchTasks()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let taskDetailsVC = segue.destination as? TaskDetailsViewController else { return }
        taskDetailsVC.delegate = self
        guard let task = sender as? ToDoTask else { return }
        taskDetailsVC.task = task
    }
    
    private func fetchTasks() {
        networkManager.fetchTasks(withURL: URL(string: "https://dummyjson.com/todos")) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let tasks):
                self.tasks = tasks
                tasksCountLabel.text = "\(tasks.count) Задач"
                tasksTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchData() {
        storageManager.fetchData { [unowned self] result in
            switch result {
            case .success(let tasks):
                taskList = tasks
                tasksTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barTintColor = .customWhite
        searchController.searchBar.setShowsCancelButton(false, animated: false)
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont(name: "SFProText-Regular", size: 17)
            textField.textColor = .customWhite
            
            let micImage = UIImageView(image: UIImage(systemName: "mic.fill"))
            micImage.contentMode = .scaleAspectFit
            micImage.tintColor = .customWhite
            micImage.layer.opacity = 0.5
            micImage.translatesAutoresizingMaskIntoConstraints = false
            
            searchController.searchBar.addSubview(micImage)
            
            NSLayoutConstraint.activate([
                micImage.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -8),
                micImage.centerYAnchor.constraint(equalTo: textField.centerYAnchor)
            ])
        }
    }
    
    private func updateTasksCountLabel() {
        tasksCountLabel.text = "\(taskList.count) Задач"
    }
}

 // MARK: - UITableViewDataSource
extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        isFiltering ? filteredTasks.count : tasks.count
        taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        guard let cell = cell as? TaskTableViewCell else { return UITableViewCell() }
//        let task = isFiltering
//            ? filteredTasks[indexPath.row]
//            : tasks[indexPath.row]
        let task = taskList[indexPath.row]
        cell.setSelected(selectedIndexPath == indexPath)
        cell.configure(withTask: task)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tasksTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        let selectedTask = isFiltering
//            ? filteredTasks[indexPath.row]
//            : tasks[indexPath.row]
        
        selectedIndexPath = indexPath
        tasksTableView.reloadRows(at: [indexPath], with: .none)
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(title: "Редактировать", image: UIImage(named: "customEdit")) { [unowned self] action in
                let task = taskList[indexPath.row]
                performSegue(withIdentifier: "ShowTask", sender: task)
            }
            
            let deleteAction = UIAction(title: "Удалить", image: UIImage(named: "customTrash")) { [unowned self] action in
                let task = taskList.remove(at: indexPath.row)
                tasksTableView.deleteRows(at: [indexPath], with: .automatic)
                storageManager.delete(task)
            }
            
            return UIMenu(title: "", children: [editAction, deleteAction])
        }
    }
    
    func tableView(_ tableView: UITableView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration, animator: (any UIContextMenuInteractionAnimating)?) {
        if let indexPath = selectedIndexPath {
            selectedIndexPath = nil
            tasksTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

// MARK: - UISearchResultsUpdating
extension TaskListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        let lowercasedSearchText = searchText.lowercased()
        
        filteredTasks = tasks.filter { task in
            let titleMatches = task.title.lowercased().contains(lowercasedSearchText)
            let descriptionMatches = task.description?.lowercased().contains(lowercasedSearchText) ?? false
            
            return titleMatches || descriptionMatches
        }
        
        tasksTableView.reloadData()
    }
}

// MARK: - TaskDetailsViewControllerDelegate
extension TaskListViewController: TaskDetailsViewControllerDelegate {
    func reloadData() {
        storageManager.fetchData { [unowned self] result in
            switch result {
            case .success(let tasks):
                taskList = tasks
                tasksTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

