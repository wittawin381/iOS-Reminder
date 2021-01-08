//
//  TimepickerCellVM.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 22/11/2563 BE.
//

import Foundation
import Combine

class TimepickerCellVM: CellViewModel{
    var isVisible: Bool = false
    var type: String
    var index: Int = 2
    var height: Float
    @Published var visible: Bool = false
    var identifier: String
//    var type: Type
    private var subscription = Set<AnyCancellable>()
    
    @Published var time: Date
    @Published var timeString: String = ""
    init(time:Date?, type:String) {
        self.identifier = "CustomCell"
        self.height = 60
        self.time = time ?? Date()
        self.type = type
        toString()
    }
    
    func toString() {
        $time.sink(receiveValue: {time in
            let formatter1 = DateFormatter()
            formatter1.timeStyle = .medium
            self.timeString = formatter1.string(from: time)
        }).store(in: &subscription)
        
    }
    
}
