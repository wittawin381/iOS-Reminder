//
//  DetailsModalViewController.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 2/11/2563 BE.
//

import Foundation
import UIKit
import Combine

class DetailsModalViewController : UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    
    
    var detailTable = UITableView(frame: CGRect.init(), style: .insetGrouped)
    private var viewModel: DetailsModalVM
    private var subscription = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        view.addSubview(detailTable)
        
        detailTable.estimatedRowHeight = 60
        detailTable.rowHeight = UITableView.automaticDimension
        
        initTable()
        
        
        
        
        viewModel.hidable.addRow.sink(receiveValue: {index in
            if index != nil {
                self.detailTable.insertRows(at: [index!], with: .fade)
            }
        }).store(in: &subscription)

        viewModel.hidable.deleteRow.sink(receiveValue: {index in
            if index != nil {
                self.detailTable.deleteRows(at: [index!], with: .fade)
            }
        }).store(in: &subscription)
//        switchCellChange()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.viewModel.updateReminder()
    }
    
    init(viewModel: DetailsModalVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
//        self.viewModel.addRow.sink(receiveValue: {index in
//            if index != nil {
//                self.detailTable.insertRows(at: [index!], with: .fade)
//
//            }
//        }).store(in: &subscription)
//        self.viewModel.deleteRow.sink(receiveValue: {index in
//            if index != nil {
//                self.detailTable.deleteRows(at: [index!], with: .fade)
//
//            }
//        }).store(in: &subscription)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowCount(section)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.secCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = self.viewModel.getCellVM(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.identifier,for: indexPath) as! CellWithViewModel
        cell.initCell(cellViewModel)
        return cell as! UITableViewCell
    }
            
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = DetailsModalVM.CellType(rawValue: viewModel.getCellVM(indexPath).type )
        switch type {
        case .date:
            if self.viewModel.dateCell.isEnabled{
                self.viewModel.dateCell.toggle()
            }
        case .time:
            if self.viewModel.timeCell.isEnabled {
                self.viewModel.timeCell.toggle()
            }
        default:
            return
        }
    }
    
    
    private func initTable() {
        detailTable.register(ToggleCell.self, forCellReuseIdentifier: "ToggleCell")
        detailTable.register(TextFieldCells.self, forCellReuseIdentifier: "TextField")
        detailTable.register(CalendarCell.self, forCellReuseIdentifier: "CalendarCell")
        detailTable.register(TimepickerCell.self, forCellReuseIdentifier: "CustomCell")
        detailTable.delegate = self
        detailTable.dataSource = self
        detailTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailTable.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 0),
            detailTable.rightAnchor.constraint(equalTo: view.rightAnchor,constant: 0),
            detailTable.topAnchor.constraint(equalTo: view.topAnchor,constant: 0),
            detailTable.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 0),
        ])
    }
    
}

