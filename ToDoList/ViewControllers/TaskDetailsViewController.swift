//
//  TaskDetailsViewController.swift
//  ToDoList
//
//  Created by Варвара Уткина on 19.11.2024.
//

import UIKit

final class TaskDetailsViewController: UIViewController {
    
    weak var delegate: TaskDetailsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .customYellow
    }
    
}
