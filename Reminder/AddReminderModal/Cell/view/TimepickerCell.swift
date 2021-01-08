//
//  TimepickerCell.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 22/11/2563 BE.
//

import Foundation
import UIKit
import Combine

class TimepickerCell: UITableViewCell, CellWithViewModel{
    var viewModel: CellViewModel?
    private var timepicker = UIDatePicker()
    private var subscription = Set<AnyCancellable>()
    
    func initCell(_ viewModel: CellViewModel?) {
        self.viewModel = viewModel
        (self.viewModel as! TimepickerCellVM).$time.sink(receiveValue: {date in
            self.timepicker.setDate(date, animated: true)
        }).store(in: &subscription)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        timepicker.datePickerMode = .time
        timepicker.preferredDatePickerStyle = .inline
        timepicker.addTarget(self, action: #selector(getTime), for: .valueChanged)
        contentView.addSubview(timepicker)
        initTimepicker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func getTime() {
        (self.viewModel as! TimepickerCellVM).time = timepicker.date
    }
    
    func initTimepicker() {
        timepicker.translatesAutoresizingMaskIntoConstraints = false
        timepicker.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        timepicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        timepicker.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: 10).isActive = true
    }
    
}
