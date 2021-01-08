//
//  CalendarCell.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 22/11/2563 BE.
//

import Foundation
import UIKit
import Combine

class CalendarCell: UITableViewCell, CellWithViewModel{
    var viewModel: CellViewModel?
    private var calendar = UIDatePicker()
    private var subscription = Set<AnyCancellable>()
    
    func initCell(_ viewModel: CellViewModel?) {
        self.viewModel = viewModel
        (self.viewModel as! CalendarCellVM).$date.sink(receiveValue: {date in
            self.calendar.setDate(date, animated: true)
        }).store(in: &subscription)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        calendar.datePickerMode = .date
        calendar.preferredDatePickerStyle = .inline
        calendar.addTarget(self, action: #selector(getDate), for: .valueChanged)
        contentView.addSubview(calendar)
        initCalendar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func getDate() {
        (self.viewModel as! CalendarCellVM).date = calendar.date
    }
    
    func initCalendar() {
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        calendar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        calendar.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        calendar.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    
}
