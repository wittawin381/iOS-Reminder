//
//  DetailsModal.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 15/11/2563 BE.
//

import Foundation
import Combine




protocol DetailsDelegate {
    func updateReminder(data: Reminders?)
}

class DetailsModalVM {
    var delegate : DetailsDelegate?
    var items: [[CellViewModel]]
    var reminderData : Reminders
    var dateCell = ToggleCellVM(title: "Date",subTitle: "NAKC",type: CellType.date.rawValue)
    var timeCell = ToggleCellVM(title: "Time",type: CellType.time.rawValue)
    private var flagCell = ToggleCellVM(title: "Flag",type: CellType.flag.rawValue)
    private var urlCell = TextFieldCellVM(text: "", hint: "URL",type: CellType.url.rawValue)
    var calendarCell = CalendarCellVM(date: nil,type: CellType.calendar.rawValue)
    var timepickerCell = TimepickerCellVM(time: nil, type: CellType.timepicker.rawValue)
    private var subscription = Set<AnyCancellable>()
    
    var previousIndex : IndexPath = IndexPath()
    var cellOpened : Bool = false
    var addRow = CurrentValueSubject<IndexPath?,Never>(nil)
    var deleteRow = CurrentValueSubject<IndexPath?,Never>(nil)
    var currentRow : IndexPath? = nil
    @Published var nextRow = IndexPath()
    var hidable = HidableCell()
    enum CellType : String {
        case date
        case calendar
        case time
        case timepicker
        case flag
        case image
        case imageList
        case url
    }
    
    
    init(data: Reminders) {
        self.reminderData = data
        
        items =
            [
                [
                    dateCell,
                    timeCell
                ],
                [
                    flagCell
                ],
                [
                    urlCell
                ]
            ]
        
        
        
        dateCell.toggle = {
            if !self.dateCell.isEnabled {
                self.timeCell.isEnabled = false
            }
            self.hidable.show(cell: self.calendarCell, by: self.dateCell, from: self.items, onUpdate: {cell in
                self.items = cell
            })
        }
        
        timeCell.toggle = {
            if self.timeCell.isEnabled {
                self.dateCell.isEnabled = true
            }
            self.hidable.show(cell: self.timepickerCell, by: self.timeCell, from: self.items, onUpdate: {cell in
                self.items = cell
            })
        }
        
        initData()
        
        urlCell.hint = "URL"
    }

    func initDate() {
        if reminderData.date != nil {
            calendarCell.date = reminderData.date!
            dateCell.isEnabled = true
        }
    }
    
    func initTime() {
        if reminderData.time != nil {
            timepickerCell.time = reminderData.time!
            timeCell.isEnabled = true
        }
    }
    
    func initData() {
        self.initDate()
        self.initTime()
        self.flagCell.isEnabled = reminderData.flag
        calendarCell.$dateString.assign(to: &dateCell.$subTitle)
        timepickerCell.$timeString.assign(to: &timeCell.$subTitle)
    }
    
    func rowCount(_ section: Int) -> Int {
        return self.items[section].count
    }
    
    func secCount() -> Int {
        return self.items.count
    }
    
    
    
    func getCellVM(_ indexPath: IndexPath) -> CellViewModel {
        return items[indexPath.section][indexPath.row]
    }
    
    func index(of: CellViewModel) -> Int? {
        return items[0].firstIndex(where: {$0.type == of.type})
    }
    
    func submitData() {
        self.reminderData.date = getDate(from: self.calendarCell.date, isEnabled: self.dateCell.isEnabled)
        self.reminderData.time = getTime(from: self.timepickerCell.time, isEnabled: self.timeCell.isEnabled)
        self.reminderData.flag = flagCell.isEnabled
        self.reminderData.url = getText(text:urlCell.text)
    }
    
    func updateReminder() {
        self.submitData()
        self.delegate?.updateReminder(data: reminderData)
    }
}


extension DetailsModalVM : DataManager {}
