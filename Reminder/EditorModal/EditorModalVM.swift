//
//  EditorViewModel.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 31/12/2563 BE.
//

import Foundation
import Combine

class EditorModalVM {
    var items : [[CellViewModel]]
    var title : TextFieldCellVM
    var note : TextFieldCellVM
    var url : TextFieldCellVM
    var date : ToggleCellVM
    var calendar : CalendarCellVM
    var time : ToggleCellVM
    var timepicker : TimepickerCellVM
    var flag : ToggleCellVM
    var reminderData : Reminders
    var list : ListSelectCellVM
    var hidable = HidableCell()
    var listModalVM = ListModalVM()
    var index : Int = 0
    var subscription = Set<AnyCancellable>()
    var onCancel : ()->Void = {}
    var onDone : ()->Void = {}
    enum CellType :String {
        case title
        case note
        case url
        case date
        case calendar
        case list
        case time
        case timepicker
        case flag
    }
    
    init(_ data: Reminders = DatabaseManager.db.createReminder(),index: Int = 0) {
        self.index = index
        listModalVM.selectedIndex.value = index
        self.reminderData = data
        title = TextFieldCellVM(text: data.title ?? "", hint: "title", type: CellType.title.rawValue)
        note = TextFieldCellVM(text: data.note ?? "", hint: "note", type: CellType.note.rawValue)
        url = TextFieldCellVM(text: data.url ?? "", hint: "URL", type: CellType.url.rawValue)
        date = ToggleCellVM(title: "Date", type: CellType.date.rawValue)
        calendar = CalendarCellVM(date: reminderData.date ,type: CellType.calendar.rawValue)
        time = ToggleCellVM(title: "Time", type: CellType.time.rawValue)
        timepicker = TimepickerCellVM(time: reminderData.time, type: CellType.timepicker.rawValue)
        flag = ToggleCellVM(title: "Flag", type: CellType.flag.rawValue)
        list = ListSelectCellVM(title: DatabaseManager.db.getListFromIndex(self.index).title ?? "", type: CellType.list.rawValue)
        
        self.items = [
            [
                title,
                note,
                url,
            ],
            [
                date,
                time
            ],
            [
                list
            ],
            [
                flag
            ]
        ]
        
        date.toggle = {
            if !self.date.isEnabled {
                self.time.isEnabled = false
            }
            self.hidable.show(cell: self.calendar, by: self.date, from: self.items, onUpdate: {cell in
                self.items = cell
            })
        }
        
                
        time.toggle = {
            if self.time.isEnabled {
                self.date.isEnabled = true
            }
            self.hidable.show(cell: self.timepicker, by: self.time, from: self.items, onUpdate: {cell in
                self.items = cell
            })
        }
        initData()
    }
    func initDate() {
        if reminderData.date != nil {
            calendar.date = reminderData.date!
            date.isEnabled = true
        }
    }
    
    func updateData() {
        self.reminderData.title = self.title.text == "" ? "New Reminder" : self.title.text
        self.reminderData.belongTo = DatabaseManager.db.getListFromIndex(self.index)
        self.reminderData.date = getDate(from: calendar.date, isEnabled: date.isEnabled)
        self.reminderData.time = getTime(from: timepicker.time, isEnabled: time.isEnabled)
        self.reminderData.flag = self.flag.isEnabled
        self.reminderData.note = getText(text:self.note.text)
        self.reminderData.url = getText(text:self.url.text)
        DatabaseManager.db.updateData()
        if reminderData.date == nil {
            NotificationManager.noti.remove(identifier: reminderData.id!.uuidString)
        }
        NotificationManager.noti.update(from: self.reminderData)
    }
    
    func initTime() {
        if reminderData.time != nil {
            timepicker.time = reminderData.time!
            time.isEnabled = true
        }
    }
    
    func setSelectedList() {
        listModalVM.selectedIndex.sink(receiveValue: {value in
            self.index = value
            let title = DatabaseManager.db.getListFromIndex(self.index).title ?? ""
            self.list.setTitle(title: title)
        }).store(in: &subscription)
        
    }
    
    func initData() {
        self.initDate()
        self.initTime()
        self.flag.isEnabled = reminderData.flag
        calendar.$dateString.assign(to: &date.$subTitle)
        timepicker.$timeString.assign(to: &time.$subTitle)
        setSelectedList()
    }
    
    func getCellVM(_ indexPath: IndexPath) -> CellViewModel {
        return items[indexPath.section][indexPath.row]
    }
    
    func secCount() -> Int {
        return items.count
    }
    
    func rowCount(_ section: Int) -> Int {
        return items[section].count
    }
}


extension EditorModalVM : DataManager {}
