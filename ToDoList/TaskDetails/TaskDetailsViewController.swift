//
//  TaskDetailsViewController.swift
//  textApp
//
//  Created by Варвара Уткина on 21.01.2025.
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
    
    // MARK: - UI Components
    private lazy var taskTitleTF: UITextField = {
        let text = UITextField()
        text.placeholder = "Новая задача"
        text.borderStyle = .roundedRect
        text.textAlignment = .left
        text.font = UIFont(name: "SFProText-Bold", size: 34)
        text.backgroundColor = .clear
        text.textColor = .customWhite
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private lazy var taskDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата"
        label.font = UIFont(name: "SFProText-Regular", size: 12)
        label.textColor = .customWhite
        label.layer.opacity = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var taskDescriptionTV: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .customWhite
        textView.font = UIFont(name: "SFProText-Regular", size: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Готово"
        button.style = .plain
        button.target = self
        button.action = #selector(doneButtonAction)
        return button
    }()
    
    // MARK: - Public properties
    var task: ToDoTask?
    var presenter: TaskDetailsViewOutputProtocol!
    var configurator: TaskDetailsConfiguratorInputProtocol = TaskDetailsConfigurator()
    
    weak var delegate: TaskDetailsViewControllerDelegate?

    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .screen
        
        configurator.configure(with: self, and: task)
        presenter.showTask()
        
        add(subviews: taskTitleTF, taskDateLabel, taskDescriptionTV)
        setupConstraints()
        
        setupNavBar()
    }
    
    // MARK: - Private Methods
    @objc private func doneButtonAction() {
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

// MARK: - Setup UI
private extension TaskDetailsViewController {
    func add(subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                taskTitleTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                taskTitleTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                taskTitleTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                taskTitleTF.heightAnchor.constraint(equalToConstant: 42.5)
            ]
        )
        
        NSLayoutConstraint.activate(
            [
                taskDateLabel.topAnchor.constraint(equalTo: taskTitleTF.bottomAnchor, constant: 8),
                taskDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                taskDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ]
        )
        
        NSLayoutConstraint.activate(
            [
                taskDescriptionTV.topAnchor.constraint(equalTo: taskDateLabel.bottomAnchor, constant: 16),
                taskDescriptionTV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                taskDescriptionTV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                taskDescriptionTV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ]
        )
    }
    
    func setupNavBar() {
        navigationController?.overrideUserInterfaceStyle = .dark
        navigationController?.navigationBar.tintColor = .customYellow
        navigationItem.rightBarButtonItem = doneButton
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

