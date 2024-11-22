//
//  TaskDetailsViewController.swift
//  ToDoList
//
//  Created by Варвара Уткина on 19.11.2024.
//

import UIKit

protocol TaskDetailsViewInputProtocol: AnyObject {
    func displayTaskTitle(_ title: String?)
    func displayTaskDescription(_ description: String?)
    func displayTaskDate(_ date: String)
    func doneButtonTapped(withAlert alert: Bool)
}

protocol TaskDetailsViewOutputProtocol {
    init(view: TaskDetailsViewInputProtocol)
    func showTask()
    func doneButtonTapped(withTitle title: String?, andDescription description: String?)
}

final class TaskDetailsViewController: UIViewController {
    
    @IBOutlet var taskTitleTF: UITextField!
    @IBOutlet var taskDescriptionTV: UITextView!
    @IBOutlet var taskDateLabel: UILabel!
    
    var task: ToDoTask?
    var presenter: TaskDetailsViewOutputProtocol!
    var configurator: TaskDetailsConfiguratorInputProtocol = TaskDetailsConfigurator()
    
    weak var delegate: TaskDetailsViewControllerDelegate?
    private let storageManager = StorageManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self, and: task)
        
        navigationController?.overrideUserInterfaceStyle = .dark
        navigationController?.navigationBar.tintColor = .customYellow
        presenter.showTask()
    }
    
    @IBAction func doneButtonAction(_ sender: UIBarButtonItem) {
        taskTitleTF.resignFirstResponder()
        taskDescriptionTV.resignFirstResponder()
        
        presenter.doneButtonTapped(
            withTitle: taskTitleTF.text,
            andDescription: taskDescriptionTV.text
        )
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Отсутствует заголовок",
            message: "Пожалуйста, заполните заголовок у задачи",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true) { [weak self] in
            guard let self else { return }
            taskTitleTF.becomeFirstResponder()
        }
    }
}

// MARK: - TaskDetailsViewInputProtocol
extension TaskDetailsViewController: TaskDetailsViewInputProtocol {
    func displayTaskTitle(_ title: String?) {
        taskTitleTF.text = title
    }
    
    func displayTaskDescription(_ description: String?) {
        taskDescriptionTV.text = description
    }
    
    func displayTaskDate(_ date: String) {
        taskDateLabel.text = date
    }
    
    func doneButtonTapped(withAlert alert: Bool) {
        if alert {
            showAlert()
            return
        }
        
        delegate?.reloadData()
        if let navigationController {
            navigationController.popViewController(animated: true)
        }
    }
}
