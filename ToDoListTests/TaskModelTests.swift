//
//  TaskModelTests.swift
//  ToDoListTests
//
//  Created by Варвара Уткина on 21.11.2024.
//

import XCTest
@testable import ToDoList

final class TaskModelTests: XCTestCase {
    
    func testDecodingTasksListSuccess() {
        let json = """
        {
            "todos": [
                {
                    "todo": "Foo",
                    "description": "Bar",
                    "date": "2023-10-10T10:00:00Z",
                    "completed": true
                },
                {
                    "todo": "Baz",
                    "completed": false
                }
                    ]
        }
        """
        guard let jsonData = json.data(using: .utf8) else {
            XCTFail("jsonData wasn't created")
            return
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let taskList = try decoder.decode(TasksList.self, from: jsonData)
            XCTAssertEqual(taskList.todos.count, 2)
            
            let firstTask = taskList.todos.first
            XCTAssertEqual(firstTask?.title, "Foo")
            XCTAssertEqual(firstTask?.description, "Bar")
            XCTAssertEqual(firstTask?.isCompleted, true)
            XCTAssertNotNil(firstTask?.date)
            
            let secondTask = taskList.todos.last
            XCTAssertEqual(secondTask?.title, "Baz")
            XCTAssertNil(secondTask?.description)
            XCTAssertEqual(secondTask?.isCompleted, false)
            XCTAssertNil(secondTask?.date)
        } catch {
            XCTFail("Decoding failed with error: \(error)")
        }
    }
    
    func testDecodingTasksListMissingKeys() {
        let json = """
            {
                "todos": [
                    {
                        "todo": "Foo",
                        "completed": true
                    }
                ]
            }
        """
        guard let jsonData = json.data(using: .utf8) else {
            XCTFail("jsonData wasn't created")
            return
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let taskList = try decoder.decode(TasksList.self, from: jsonData)
            XCTAssertEqual(taskList.todos.count, 1)
            
            let task = taskList.todos.first
            XCTAssertEqual(task?.title, "Foo")
            XCTAssertNil(task?.description)
            XCTAssertEqual(task?.isCompleted, true)
            XCTAssertNil(task?.date)
        } catch {
            XCTFail("Decoding failed with error: \(error)")
        }
    }
    
    func testDecodingTasksListInvalidData() {
        let json = """
            {
                "todos": [
                    {
                        "todo": "Foo",
                        "date": "InvalidDate",
                        "completed": true
                    }
                ]
            }
        """
        guard let jsonData = json.data(using: .utf8) else {
            XCTFail("jsonData wasn't created")
            return
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            _ = try decoder.decode(TasksList.self, from: jsonData)
            XCTFail("Expected decoding to fail with invalid date format")
        } catch {
            XCTAssertTrue(error is DecodingError, "Expected a DecodingError but got \(type(of: error))")
        }
    }
    
    func testDecodingEmptyTasksList() {
        let json = """
            {
                "todos": []
            }
        """
        guard let jsonData = json.data(using: .utf8) else {
            XCTFail("jsonData wasn't created")
            return
        }
        let decoder = JSONDecoder()
        
        do {
            let tasksList = try decoder.decode(TasksList.self, from: jsonData)
            XCTAssertEqual(tasksList.todos.count, 0)
        } catch {
            XCTFail("Decoding failed with error: \(error)")
        }
    }

}
