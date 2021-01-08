//
//  EditorModal.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 31/12/2563 BE.
//

import Foundation
import UIKit
import Combine

class EditorModalView : UIViewController {
    var viewModel: EditorModalVM?
    var subscription = Set<AnyCancellable>()
    var tableView = UITableView(frame:CGRect.zero,style: .insetGrouped)
    
    override func viewDidLoad() {
        view.addSubview(tableView)
        initTable()
        viewModel?.hidable.addRow.sink(receiveValue: {index in
            if index != nil {
                self.tableView.insertRows(at: [index!], with: .fade)
            }
        }).store(in: &subscription)

        viewModel?.hidable.deleteRow.sink(receiveValue: {index in
            if index != nil {
                self.tableView.deleteRows(at: [index!], with: .fade)
            }
        }).store(in: &subscription)
    
        navigationItem(left: cancelButton(), right: doneButton())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func initTable() {
        tableView.register(ToggleCell.self, forCellReuseIdentifier: "ToggleCell")
        tableView.register(TextFieldCells.self, forCellReuseIdentifier: "TextField")
        tableView.register(CalendarCell.self, forCellReuseIdentifier: "CalendarCell")
        tableView.register(TimepickerCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.register(ListSelectCell.self, forCellReuseIdentifier: "ListCell")
        tableView.register(DetailCell.self, forCellReuseIdentifier: "DetailCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 0),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor,constant: 0),
            tableView.topAnchor.constraint(equalTo: view.topAnchor,constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 0),
        ])
    }
    
    func cancelButton() -> UIBarButtonItem {
        let button = UIBarButtonItem()
        button.title = "Cancel"
        button.target = self
        button.action = #selector(cancelPressed)
        return button
    }
    
    func doneButton() -> UIBarButtonItem {
        let button = UIBarButtonItem()
        button.title = "Done"
        button.target = self
        button.action = #selector(donePressed)
        return button
    }
    
    func navigationItem(left: UIBarButtonItem, right: UIBarButtonItem) {
        self.navigationItem.leftBarButtonItem = left
        self.navigationItem.rightBarButtonItem = right
    }
    
    @objc func cancelPressed() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        viewModel?.onCancel()
    }
    
    @objc func donePressed() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        viewModel?.updateData()
        viewModel?.onDone()
    }
}

extension EditorModalView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.rowCount(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = self.viewModel?.getCellVM(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel?.identifier ?? "", for:  indexPath ) as! CellWithViewModel
        cell.initCell(viewModel)
        return cell as! UITableViewCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.secCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = EditorModalVM.CellType(rawValue: viewModel?.getCellVM(indexPath).type ?? "")
        switch type {
        case .list:
            EditorRouter(self).toSelecGroupPage(viewModel: self.viewModel!.listModalVM)
        case .date:
            if self.viewModel?.date.isEnabled ?? false {
                self.viewModel?.date.toggle()
            }
        case .time:
            if self.viewModel?.time.isEnabled ?? false {
                self.viewModel?.time.toggle()
            }
        default:
            return
        }
    }
}
