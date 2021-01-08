//
//  TextFieldVM.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 11/11/2563 BE.
//

import Foundation
import Combine


class TextFieldCellVM: CellViewModel {
    var type: String
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    var viewModel: CellViewModel?
    var identifier: String
    @Published var text: String
    var hint: String
    init(text: String, hint:String, type: String) {
        self.identifier = "TextField"
        self.text = text
        self.hint = hint
        self.type = type
    }
    
    
    
}
