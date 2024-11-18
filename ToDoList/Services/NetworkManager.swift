//
//  NetworkManager.swift
//  ToDoList
//
//  Created by Варвара Уткина on 18.11.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingError
    case noData
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchTasks(withURL url: URL?, completion: @escaping(Result<[Task], NetworkError>) -> Void) {
        guard let url else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil {
                print(error?.localizedDescription ?? "No error description")
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let tasksList = try decoder.decode(TasksList.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(tasksList.todos))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
