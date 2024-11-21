//
//  TaskListViewControllerTests.swift
//  TaskListViewControllerTests
//
//  Created by Варвара Уткина on 21.11.2024.
//

import XCTest
@testable import ToDoList

final class TaskListViewControllerTests: XCTestCase {
    
    var sut: TaskListViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: "TaskListViewController") as? TaskListViewController
        
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testWhenViewIsLoadedTasksTableViewIsNotNil() {
        XCTAssertNotNil(sut.tasksTableView)
    }
}
