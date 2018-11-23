//
//  JZYIToDoStore.swift
//  SwiftL
//
//  Created by kaisa-ios-001 on 2018/11/23.
//  Copyright © 2018年 Giga. All rights reserved.
//

import Foundation

extension Notification {
    struct UserInfoKey<ValueType>: Hashable {
        let key: String
    }
    
    func getUserInfo<T>(for key: Notification.UserInfoKey<T>) -> T {
        return userInfo![key] as! T
    }
}

extension Notification.Name {
    static let toDoStoreDidChangedNotification = Notification.Name(rawValue: "com.onevcat.app.ToDoStoreDidChangedNotification")
}

extension Notification.UserInfoKey {
    static var toDoStoreDidChangedChangeBehaviorKey: Notification.UserInfoKey<JZYIToDoStore.ChangeBehavior> {
        return Notification.UserInfoKey(key: "com.onevcat.app.ToDoStoreDidChangedNotification.ChangeBehavior")
    }
}

extension NotificationCenter {
    func post<T>(name aName: NSNotification.Name, object anObject: Any?, typedUserInfo aUserInfo: [Notification.UserInfoKey<T> : T]? = nil) {
        post(name: aName, object: anObject, userInfo: aUserInfo)
    }
}

// 定义简单的 ToDo Model
struct ToDoItem {
    let id: UUID
    let title: String
    
    init(title: String) {
        self.id = UUID()
        self.title = title
    }
}

class JZYIToDoStore {
    
    enum ChangeBehavior {
        case add([Int])
        case remove([Int])
        case reload
    }

    //演示用单例，基本上不用
    static let shared = JZYIToDoStore()
    
    static func diff(original: [ToDoItem], now: [ToDoItem]) -> ChangeBehavior {
        let originalSet = Set(original)
        let nowSet = Set(now)
        
        if originalSet.isSubset(of: nowSet) { // Appended
            let added = nowSet.subtracting(originalSet)
            let indexes = added.compactMap { now.index(of: $0) }
            return .add(indexes)
        } else if (nowSet.isSubset(of: originalSet)) { // Removed
            let removed = originalSet.subtracting(nowSet)
            let indexes = removed.compactMap { original.index(of: $0) }
            return .remove(indexes)
        } else { // Both appended and removed
            return .reload
        }
    }

    private var items: [ToDoItem] = [] {
        didSet {
            let behavior = JZYIToDoStore.diff(original: oldValue, now: items)
            NotificationCenter.default.post(
                name: .toDoStoreDidChangedNotification,
                object: self,
                typedUserInfo: [.toDoStoreDidChangedChangeBehaviorKey: behavior]
            )
        }
    }

    private init() {}
    
    func append(item: ToDoItem) {
        items.append(item)
    }
    
    func append(newItems: [ToDoItem]) {
        items.append(contentsOf: newItems)
    }
    
    func remove(item: ToDoItem) {
        guard let index = items.index(of: item) else { return }
        remove(at: index)
    }
    
    func remove(at index: Int) {
        items.remove(at: index)
    }
    
    func edit(original: ToDoItem, new: ToDoItem) {
        guard let index = items.index(of: original) else { return }
        items[index] = new
    }
    
    var count: Int {
        return items.count
    }
    
    func item(at index: Int) -> ToDoItem {
        return items[index]
    }
    
//    func getAll(completion: @escaping (([ToDoItem]?, Error?) -> Void)?) {
//        //        NetworkService.getExistingToDoItems { response, error in
//        //            if let error = error {
//        //                completion?(nil, error)
//        //            } else {
//        //                self.items = response.items
//        //                completion?(response.items, nil)
//        //            }
//        //        }
//    }

}

extension ToDoItem: Hashable {
    var hashValue: Int {
        return id.hashValue
    }
}
extension ToDoItem: Equatable {
    public static func == (lhs: ToDoItem, rhs: ToDoItem) -> Bool {
        return lhs.id == rhs.id
    }
}
