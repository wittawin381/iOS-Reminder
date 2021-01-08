//
//  ToggleCellVM.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 19/11/2563 BE.
//

import Foundation
import Combine


class ToggleCellVM: CellViewModel{
    var type: String
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    var identifier: String
    var title: String
    var enabled: Bool
    @Published var subTitle: String
    @Published var isEnabled: Bool
    private var subscription = Set<AnyCancellable>()
    var toggle : ()->Void = {}
    
    init(title: String,subTitle: String = "", enabled: Bool = false, type: String) {
        self.title = title
        self.subTitle = subTitle
        self.enabled = enabled
        self.identifier = "ToggleCell"
        self.type = type
        self.isEnabled = enabled
    }
        
    func setSubTitle(subTitle: String) {
        self.subTitle = subTitle
    }
    
    func onToggle() {
        self.isEnabled.toggle()
        toggle()
    }
    
    func onTap() {
        
    }
    

}
