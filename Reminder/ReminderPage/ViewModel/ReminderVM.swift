//
//  ReminderVM.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 20/12/2563 BE.
//

import Foundation


class ReminderVM {
    var title : String = ""
    var list : List?
    var items : [Reminders]
    var index : Int = 0
    var state : State = .all
    
    enum State {
        case uncomplete
        case all
    }
    
    init(index: Int = 0) {
        self.index = index
        self.items = list?.contain?.array as? [Reminders] ?? []
    }
    
    func initData() {
        switch state {
        case .all:
            items = list?.contain?.array.filter({!($0 as! Reminders).complete && ($0 as! Reminders).belongTo == list}) as! [Reminders]
            items += list?.contain?.array.filter({($0 as! Reminders).complete && ($0 as! Reminders).belongTo == list}) as! [Reminders]
        case .uncomplete:
            items = list?.contain?.array.filter({!($0 as! Reminders).complete && ($0 as! Reminders).belongTo == list}) as! [Reminders]
        }
    }
    
    func isIndexChanged(item: Reminders) -> Bool{
        var tempItemAll = [Reminders]()
        var tempItemUC = [Reminders]()
        tempItemAll = list?.contain?.array.filter({!($0 as! Reminders).complete}) as! [Reminders]
        tempItemAll += list?.contain?.array.filter({($0 as! Reminders).complete}) as! [Reminders]
        tempItemUC = list?.contain?.array as! [Reminders]
        
        return tempItemAll.firstIndex(of: item) == tempItemUC.firstIndex(of: item)
    }
}
