//
//  ViewController.swift
//  ToDoList
//
//  Created by Варвара Уткина on 18.11.2024.
//

import UIKit

final class TaskListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTasks()
    }
    
    private func fetchTasks() {
        URLSession.shared.dataTask(with: URL(string: "https://dummyjson.com/todos")!) { data, _, error in
            if let error {
                print(error.localizedDescription)
            }
            
            guard let data else {
                print("No data")
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            }
        }.resume()
    }


}

