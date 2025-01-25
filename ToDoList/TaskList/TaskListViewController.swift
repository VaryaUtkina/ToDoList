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
    
    private lazy var taskTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TasksCell")
        return tableView
    }()
    
    private lazy var pencilButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .customYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self,
            action: #selector(openTaskDetails),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var bottomView: UIView = {
        let customView = UIView()
        customView.backgroundColor = .stroke
        customView.translatesAutoresizingMaskIntoConstraints = false
        return customView
    }()
    
    private lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.text = "Task"
        label.textColor = .customWhite
        label.font = UIFont(name: "SFProText-Regular", size: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Private Properties
    private var taskList: [ToDoTask] = [] {
        didSet {
            updateTasksCountLabel()
        }
    }
    private let networkManager = NetworkManager.shared
    private let storageManager = StorageManager.shared
    private let dataManager = DataManager.shared
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredTaskList: [ToDoTask] = []
    private var selectedIndexPath: IndexPath?
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    
    //в loadView перевести всю верстку
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews(taskTableView, bottomView)
        bottomView.addSubview(pencilButton)
        bottomView.addSubview(taskLabel)
        
        view.backgroundColor = .screen
        
        setupConstraints()
        setupNavBar()
        
        setupSearchController()
        createTempData { [unowned self] in
            fetchData()
        }
    }
    
    // MARK: - Private Methods
    private func createTempData(completion: @escaping() -> Void) {
        if !UserDefaults.standard.bool(forKey: "done") {
            dataManager.createTempData {
                UserDefaults.standard.set(true, forKey: "done")
                completion()
            }
        } else {
            completion()
        }
    }
    
    private func fetchData() {
        storageManager.fetchData { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let tasks):
                taskList = tasks
                DispatchQueue.main.async {
                    self.taskTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc private func openTaskDetails() {
        let taskDetailsVC = TaskDetailsViewController()
        taskDetailsVC.delegate = self
        navigationController?.pushViewController(taskDetailsVC, animated: true)
    }
}

 // MARK: - UITableViewDataSource
extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredTaskList.count : taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath)
        guard let cell = cell as? TaskTableViewCell else { return UITableViewCell() }
        let task = isFiltering
            ? filteredTaskList[indexPath.row]
            : taskList[indexPath.row]
        cell.setSelected(selectedIndexPath == indexPath)
        cell.configure(withTask: task)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.searchBar.resignFirstResponder()
        taskTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        selectedIndexPath = indexPath
        taskTableView.reloadRows(at: [indexPath], with: .none)
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(title: "Редактировать", image: UIImage(named: "customEdit")) { [unowned self] action in
                let task = taskList[indexPath.row]
                let taskDetailsVC = TaskDetailsViewController()
                taskDetailsVC.task = task
                taskDetailsVC.delegate = self
                navigationController?.pushViewController(taskDetailsVC, animated: true)
            }
            
            let deleteAction = UIAction(title: "Удалить", image: UIImage(named: "customTrash")) { [unowned self] action in
                let task = taskList.remove(at: indexPath.row)
                taskTableView.deleteRows(at: [indexPath], with: .automatic)
                storageManager.delete(task)
            }
            
            return UIMenu(title: "", children: [editAction, deleteAction])
        }
    }
    
    func tableView(_ tableView: UITableView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration, animator: (any UIContextMenuInteractionAnimating)?) {
        if let indexPath = selectedIndexPath {
            selectedIndexPath = nil
            taskTableView.reloadRows(at: [indexPath], with: .none)
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
        
        filteredTaskList = taskList.filter { task in
            let titleMatches = task.title?.lowercased().contains(lowercasedSearchText)
            let descriptionMatches = task.taskDescription?.lowercased().contains(lowercasedSearchText) ?? false
            
            return titleMatches ?? false || descriptionMatches
        }
        
        taskTableView.reloadData()
    }
}

// MARK: - UIScrollViewDelegate
extension TaskListViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
}

// MARK: - TaskDetailsViewControllerDelegate
extension TaskListViewController: TaskDetailsViewControllerDelegate {
    func reloadData() {
        storageManager.fetchData { [unowned self] result in
            switch result {
            case .success(let tasks):
                taskList = tasks.sorted { $0.date ?? Date() > $1.date ?? Date() }
                taskTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

private extension TaskListViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            taskTableView.topAnchor.constraint(equalTo: view.topAnchor),
            taskTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            taskTableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 89)
        ])
        
        NSLayoutConstraint.activate([
            pencilButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -34),
            pencilButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            pencilButton.widthAnchor.constraint(equalToConstant: 49),
            pencilButton.widthAnchor.constraint(equalTo: pencilButton.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            taskLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -34),
            taskLabel.heightAnchor.constraint(equalToConstant: 49),
            taskLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor)
        ])
    }
    
    func setupNavBar() {
        overrideUserInterfaceStyle = .dark
        navigationController?.overrideUserInterfaceStyle = .dark
        
        title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        
        navBarAppearance.backgroundColor = .screen
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.customWhite]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.customWhite]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    func setupSearchController() {
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
            
            if let clearButton = textField.value(forKey: "clearButton") as? UIButton {
                clearButton.isHidden = true
            }
            
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
    
    func updateTasksCountLabel() {
        taskLabel.text = "\(taskList.count) Задач"
    }
}
