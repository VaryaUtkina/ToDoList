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
    
    weak var delegate: TaskDetailsViewControllerDelegate?
    private let storageManager = StorageManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskDateLabel.text = Date().formatted()
        navigationController?.navigationBar.tintColor = .customYellow
    }
    
    @IBAction func doneButtonAction(_ sender: UIBarButtonItem) {
        taskTitleTF.resignFirstResponder()
        taskDescriptionTV.resignFirstResponder()
        
        guard let title = taskTitleTF.text, !title.isEmpty else {
            showAlert()
            return
        }
        
        print("Creating task with title: \(title) and description: \(taskDescriptionTV.text ?? "")")
        storageManager.create(title, taskDescriptionTV.text)
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
}
