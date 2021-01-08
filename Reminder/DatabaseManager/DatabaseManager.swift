//
//  ReminderGroupModel.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 29/10/2563 BE.
//

import Foundation
import CoreData
import UIKit
import Combine

class DatabaseManager {
    static let db = DatabaseManager()
    var list = CurrentValueSubject<[List], Error>([]);
    private var context : NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init() {
        self.list.value = fetchData()
    }
    
    func fetchData() -> [List] {
        return try! context.fetch(List.fetchRequest()) as! [List]
    }
    
    private func reloadData() {
        self.list.value = fetchData()
        self.list.send(self.list.value)
    }
    
    func initDefaultList() {
        if self.list.value.count == 0 {
            addList(title: "Reminders")
        }
    }
    
    public func addList(title: String) {
        let newGroup = List(context: self.context)
        newGroup.title = title
        try? self.context.save()
        self.reloadData()
    }
    
    public func removeData(item: NSManagedObject) {
        self.context.delete(item)
        try? self.context.save()
        self.reloadData()
    }
    
    public func getLists() -> CurrentValueSubject<[List], Error> {
        self.list.value = fetchData()
        return self.list
    }
    
    public func getListFromIndex(_ index: Int) -> List {
        if self.list.value.count <= 0 {
            return List(context: context)
        }
        return self.list.value[index]
    }
    
    public func getReminders(from: List) -> [Reminders] {
        return from.contain?.array as! [Reminders]
    }
    
    public func addReminder(_ item: Reminders, to: List) {
        to.addToContain(item)
        try? self.context.save()
        self.reloadData()
    }
    
    func createReminder() -> Reminders {
        return Reminders(context: context)
    }
    
    func complete(id: UUID) {
        let reminder = allReminder().first(where: {$0.id==id})
        reminder?.complete = true
    }
    
    func updateData() {
        try? self.context.save()
    }
    
    func allReminder() -> [Reminders]{
        var list : [Reminders] = []
        list = try! (context.fetch(Reminders.fetchRequest()) as? [Reminders])?.filter({$0.belongTo != nil}) ?? []
        return list
    }
}
