//
//  TableViewController.swift
//  SwiftL
//
//  Created by kaisa-ios-001 on 2018/11/23.
//  Copyright © 2018年 Giga. All rights reserved.
//

import UIKit

let inputCellReuseId = "inputCell"
let todoCellReuseId = "todoCell"

class TableViewController: UITableViewController {
    struct State {
        let todos: [String]
        let text: String
    }
    
    var state = State(todos: [], text: "") {
        didSet {
            if oldValue.todos != state.todos {
                tableView.reloadData()
                title = "TODO - (\(state.todos.count))"
            }
            
            if (oldValue.text != state.text) {
                let isItemLengthEnough = state.text.count >= 3
                navigationItem.rightBarButtonItem?.isEnabled = isItemLengthEnough
                
                let inputIndexPath = IndexPath(row: 0, section: Section.input.rawValue)
                let inputCell = tableView.cellForRow(at: inputIndexPath) as? TableViewInputCell
                inputCell?.textField.text = state.text
            }
        }
    }
    
    enum Section: Int {
        case input = 0, todos, max
    }
    
    var todos: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ToDoStore.shared.getToDoItems { (data) in
            self.state = State(todos: self.state.todos + data, text: self.state.text)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.max.rawValue
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            fatalError()
        }
        switch section {
        case .input: return 1
        case .todos: return state.todos.count
        case .max: fatalError()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError()
        }
        
        switch section {
        case .input:
            let cell = tableView.dequeueReusableCell(withIdentifier: inputCellReuseId, for: indexPath) as! TableViewInputCell
            cell.delegate = self
            return cell
        case .todos:
            let cell = tableView.dequeueReusableCell(withIdentifier: todoCellReuseId, for: indexPath)
            cell.textLabel?.text = state.todos[indexPath.row]
            return cell
        default:
            fatalError()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == Section.todos.rawValue else {
            return
        }
        
        let newTodos = Array(state.todos[..<indexPath.row] + state.todos[(indexPath.row + 1)...])
        state = State(todos: newTodos, text: state.text)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        state = State(todos: [state.text] + state.todos, text: "")
    }
}

extension TableViewController: TableViewInputCellDelegate {
    func inputChanged(cell: TableViewInputCell, text: String) {
        state = State(todos: state.todos, text: text)
    }
}
