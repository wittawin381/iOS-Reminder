//
//  DetailCellVM.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 19/11/2563 BE.
//

import Foundation


class DetailCellVM: CellViewModel{
    var type: String
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    var title: String
    var identifier: String
    
    
    init(title: String, type: String) {
        identifier = "DetailCell"
        self.title = title
        self.type = type
    }
}
