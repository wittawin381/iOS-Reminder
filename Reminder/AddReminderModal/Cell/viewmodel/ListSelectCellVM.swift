//
//  PageRouteCellVM.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 14/11/2563 BE.
//

import Foundation


class ListSelectCellVM: CellViewModel{
    var type: String
    
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    var identifier: String
    var title: String
    init(title: String, type: String) {
        self.identifier = "ListCell"
        self.title = title
        self.type = type
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func setTitle(title: String) {
        self.title = title
    }
}
