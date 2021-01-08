//
//  ListModalVM.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 18/11/2563 BE.
//

import Foundation
import Combine

class ListModalVM {
    var selectedIndex = CurrentValueSubject<Int,Never>(0)
    private var items: [List]
    init() {
        self.items = DatabaseManager.db.getLists().value
    }
    
    func getList() -> [List] {
        return self.items
    }
    
    func count() -> Int {
        return self.items.count
    }
    
    func getItem(_ indexPath: IndexPath) -> List {
        return self.items[indexPath.row]
    }
    
    func setIndex(_ indexPath: IndexPath) {
        self.selectedIndex.value = indexPath.row
    }
    
    func getSelectedIndex() -> CurrentValueSubject<Int,Never> {
        return selectedIndex
    }
}
