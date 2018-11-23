//
//  JZYIToDoListVC.swift
//  SwiftL
//
//  Created by kaisa-ios-001 on 2018/11/23.
//  Copyright © 2018年 Giga. All rights reserved.
//

import UIKit

//理想化的数据流动应该是单向的：UI 操作 -> 经由 View Controller 进行模型更新 -> 新的模型经由 View Controller 更新 UI -> 等待新的 UI 操作

private let cellIdentifier = "ToDoItemCell"

class JZYIToDoListVC: UITableViewController {

    weak var addButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        addButton = navigationItem.rightBarButtonItem
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(todoItemsDidChange),
            name: .toDoStoreDidChangedNotification,
            object: nil)
    }
    
    private func syncTableView(for behavior: JZYIToDoStore.ChangeBehavior) {
        switch behavior {
        case .add(let indexes):
            let indexPathes = indexes.map { IndexPath(row: $0, section: 0) }
            tableView.insertRows(at: indexPathes, with: .automatic)
        case .remove(let indexes):
            let indexPathes = indexes.map { IndexPath(row: $0, section: 0) }
            tableView.deleteRows(at: indexPathes, with: .automatic)
        case .reload:
            tableView.reloadData()
        }
    }
    
    private func updateAddButtonState() {
        addButton?.isEnabled = JZYIToDoStore.shared.count < 10
    }
    
    @objc func todoItemsDidChange(_ notification: Notification) {
        let behavior = notification.getUserInfo(for: .toDoStoreDidChangedChangeBehaviorKey)
        syncTableView(for: behavior)
        updateAddButtonState()
    }
    
    // 点击添加按钮
    @objc func addButtonPressed(_ sender: Any) {
        let store = JZYIToDoStore.shared
        let newCount = store.count + 1
        let title = "ToDo Item \(newCount)"
        
        store.append(item: .init(title: title))
    }

}


extension JZYIToDoListVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return JZYIToDoStore.shared.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = JZYIToDoStore.shared.item(at: indexPath.row).title
        return cell
    }
    
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, view, done in
            JZYIToDoStore.shared.remove(at: indexPath.row)
            done(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
