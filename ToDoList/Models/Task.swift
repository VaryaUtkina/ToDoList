//
//  Task.swift
//  ToDoList
//
//  Created by Варвара Уткина on 18.11.2024.
//

import Foundation

struct TasksList: Decodable {
    let todos: [Task]
}

struct Task: Decodable {
    let title: String
    let description: String?
    let date: Date?
    let isCompleted: Bool
    
    enum CodingKeys: String, CodingKey {
        case title = "todo"
        case description
        case date
        case isCompleted = "completed"
    }
}
