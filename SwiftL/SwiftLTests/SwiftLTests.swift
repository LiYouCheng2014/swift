//
//  SwiftLTests.swift
//  SwiftLTests
//
//  Created by kaisa-ios-001 on 2018/11/21.
//  Copyright © 2018年 Giga. All rights reserved.
//

import XCTest
@testable import SwiftL

class SwiftLTests: XCTestCase {

    var controller: TableViewController!
    
    override func setUp() {
        super.setUp()
        
        controller = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TableViewController") as? TableViewController
        _ = controller.view
    }

    override func tearDown() {
        controller = nil
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSettingState() {
        // 初始状态
        XCTAssertEqual(controller.tableView.numberOfRows(inSection: TableViewController.Section.todos.rawValue), 0)
        XCTAssertEqual(controller.title, "TODO - (0)")
        XCTAssertFalse(controller.navigationItem.rightBarButtonItem!.isEnabled)

        // ([], "") -> (["1", "2", "3"], "abc")
        controller.state = TableViewController.State(todos: ["1", "2", "3"], text: "abc")
        XCTAssertEqual(controller.tableView.numberOfRows(inSection: TableViewController.Section.todos.rawValue), 3)
        XCTAssertEqual(controller.tableView.cellForRow(at: todoItemIndexPath(row: 1))?.textLabel?.text, "2")
        XCTAssertEqual(controller.title, "TODO - (3)")
        XCTAssertTrue(controller.navigationItem.rightBarButtonItem!.isEnabled)

        // (["1", "2", "3"], "abc") -> ([], "")
        controller.state = TableViewController.State(todos: [], text: "")
        XCTAssertEqual(controller.tableView.numberOfRows(inSection: TableViewController.Section.todos.rawValue), 0)
        XCTAssertEqual(controller.title, "TODO - (0)")
        XCTAssertFalse(controller.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    func testAdding() {
        let testItem = "Test Item"
        
        let originalTodos = controller.state.todos
        controller.state = TableViewController.State(todos: originalTodos, text: testItem)
        controller.addButtonPressed(self)
        XCTAssertEqual(controller.state.todos, [testItem] + originalTodos)
        XCTAssertEqual(controller.state.text, "")
    }
    
    func testRemoving() {
        controller.state = TableViewController.State(todos: ["1", "2", "3"], text: "")
        controller.tableView(controller.tableView, didSelectRowAt: todoItemIndexPath(row: 1))
        XCTAssertEqual(controller.state.todos, ["1", "3"])
    }
    
    func testInputChanged() {
        controller.inputChanged(cell: TableViewInputCell(), text: "Hello")
        XCTAssertEqual(controller.state.text, "Hello")
    }

}

func todoItemIndexPath(row: Int) -> IndexPath {
    return IndexPath(row: row, section: TableViewController.Section.todos.rawValue)
}

