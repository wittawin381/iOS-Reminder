//
//  CalendarCellVM.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 22/11/2563 BE.
//

import Foundation
import Combine

class CalendarCellVM: CellViewModel{
    var type: String
    var index: Int = 1
    var height: Float
    @Published var visible: Bool = false
    var identifier: String
    @Published var date: Date
    @Published var dateString : String = ""
    
    private var subscription = Set<AnyCancellable>()
    init(date:Date?, type: String) {
        self.identifier = "CalendarCell"
        self.height = 300
        self.date = date ?? Date()
        self.type = type
        toString()
    }
    
    func toString() {
        $date.sink(receiveValue: {date in
            let formatter1 = DateFormatter()
            formatter1.dateStyle = .full
            self.dateString = formatter1.string(from: date)
        }).store(in: &subscription)
        
    }
    
    

}
