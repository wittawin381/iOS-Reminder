//
//  AddReminderViewModel.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 2/11/2563 BE.
//

import Foundation
import UIKit
import Combine


class AddReminderViewModel : DetailsDelegate {
    func updateReminder(data: Reminders?) {
        self.reminderData = data
    }
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedItem : Int = 0
    private var titleCell : TextFieldCellVM
    private var noteCell : TextFieldCellVM
    private var listModalView: ListModalViewController;
    private var detailsModalView: DetailsModalViewController;
    private var listCellVM: ListSelectCellVM
    var listModalVM: ListModalVM
    private var detailsCellVM: DetailCellVM
    var detailsModalVM: DetailsModalVM
    private var items: [[CellViewModel]];
    var onAddPressed : () -> Void = {}
    var onCancelPressed : () -> Void = {}
    
    var reminderData : Reminders?
    private var subscription = Set<AnyCancellable>()
    var index: Int = 0;
    enum CellType: String {
        case title
        case note
        case details
        case selectedGroup
    }
    
    init(_ data: Reminders = DatabaseManager.db.createReminder()) {
        self.reminderData = data
        self.listModalVM = ListModalVM()
        self.detailsModalVM = DetailsModalVM(data: reminderData!)
        self.listModalView = ListModalViewController(viewModel: listModalVM)
        self.detailsModalView = DetailsModalViewController(viewModel: detailsModalVM)
        self.detailsCellVM = DetailCellVM(title: "Deatails", type: CellType.details.rawValue)
        let title = DatabaseManager.db.getListFromIndex(index).title
        self.listCellVM = ListSelectCellVM(title: title ?? "" , type: CellType.selectedGroup.rawValue)
        titleCell = TextFieldCellVM(text: reminderData?.title ?? "", hint: "", type: CellType.title.rawValue)
        noteCell = TextFieldCellVM(text: reminderData?.note ?? "", hint: "", type: CellType.note.rawValue)
        listModalVM.selectedIndex.value = selectedItem
        
        
        self.items = [
            [
                titleCell,
                noteCell
            ],
            [
                detailsCellVM
            ],
            [
                listCellVM
            ]
        ]
        initData()
        
    }
    
    
    func initData() {
        titleCell.$text.sink(receiveValue: {text in
            self.reminderData?.title = text
        }).store(in: &subscription)
        noteCell.$text.sink(receiveValue: {text in
            self.reminderData?.note = text
        }).store(in: &subscription)
        setSelectedList()
    }
    
    func setSelectedList() {
        listModalVM.selectedIndex.sink(receiveValue: {value in
            self.index = value
            let title = DatabaseManager.db.getListFromIndex(self.index).title ?? "Null"
            self.listCellVM.setTitle(title: title)
        }).store(in: &subscription)
        
    }
    
    func submitData() {
        reminderData?.id = UUID()
        reminderData?.title = reminderData?.title == "" ? "New Reminder" : reminderData?.title
        DatabaseManager.db.addReminder(reminderData!, to: getParentList())
        DatabaseManager.db.updateData()
        NotificationManager.noti.request(from: reminderData!)
    }
    
    func getText(text: String) -> String? {
        if text == "" {
            return nil
        }
        return text
    }
    
    func setInitIndex(_ index: Int) {
        listModalVM.selectedIndex.value = index
    }
    
    func getCell(_ indexPath: IndexPath) -> CellViewModel {
        return items[indexPath.section][indexPath.row]
    }
    
    func rowCount(_ section: Int) -> Int {
        return items[section].count
    }
    
    func secCount() -> Int {
        return items.count
    }
    
    func getParentList() -> List{
        return DatabaseManager.db.getListFromIndex(self.index) 
    }
    
    func addReminder() {
        
    }
    
}

