//
//  TaskDetailsViewController.swift
//  ToDoList
//
//  Created by Варвара Уткина on 19.11.2024.
//

import UIKit

final class TaskDetailsViewController: UIViewController {
    
    @IBOutlet var taskTitleTF: UITextField!
    @IBOutlet var taskDescriptionTV: UITextView!
    @IBOutlet var taskDateLabel: UILabel!
    
    var task: ToDoTask?
    
    weak var delegate: TaskDetailsViewControllerDelegate?
    private let storageManager = StorageManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .customYellow
        setupUI()
    }
    
    @IBAction func doneButtonAction(_ sender: UIBarButtonItem) {
        taskTitleTF.resignFirstResponder()
        taskDescriptionTV.resignFirstResponder()
        
        guard let title = taskTitleTF.text, !title.isEmpty else {
            showAlert()
            return
        }
        if let task {
            storageManager.update(
                task,
                withNewTitle: title,
                AndNewDescription: taskDescriptionTV.text
            )
        } else {
            storageManager.create(title, taskDescriptionTV.text)
        }
        delegate?.reloadData()
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Отсутствует заголовок",
            message: "Пожалуйста, заполните заголовок у задачи",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true) { [unowned self] in
            taskTitleTF.becomeFirstResponder()
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: date)
    }
    
    private func setupUI() {
        taskTitleTF.text = task?.title
        taskDateLabel.text = formattedDate(task?.date ?? Date())
        taskDescriptionTV.text = task?.taskDescription
    }
}
