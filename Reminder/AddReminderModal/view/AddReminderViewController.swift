//
//  AddReminderViewController.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 23/10/2563 BE.
//

import UIKit
import Combine



class AddReminderViewController: UIViewController {

    private let cancelButton : UIBarButtonItem = UIBarButtonItem()
    private let addButton : UIBarButtonItem = UIBarButtonItem()
    private let textField : UITextField = UITextField()
    var viewModel : AddReminderViewModel?
    private var subscription = Set<AnyCancellable>()
    
    
    private let tableView :UITableView = UITableView(frame:CGRect.zero,style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Reminder"
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        initTableView()
        initNavigationBar()
        if viewModel == nil {
            viewModel = AddReminderViewModel()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
        
    func initNavigationBar(){
        cancelButton.title = "Cancel"
        cancelButton.target = self
        cancelButton.action = #selector(cancelPressed)
        
        addButton.title = "Add"
        addButton.target = self
        addButton.action = #selector(addPressed)
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func initTableView(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TextFieldCells.self, forCellReuseIdentifier: "TextField")
        tableView.register(ListSelectCell.self, forCellReuseIdentifier: "ListCell")
        tableView.register(DetailCell.self, forCellReuseIdentifier: "DetailCell")
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
    }
    
    @objc func cancelPressed(){
        dismiss(animated: true, completion: nil)
        viewModel?.onCancelPressed()
    }
    
    @objc func addPressed(){
        viewModel?.submitData()
        viewModel?.onAddPressed()
        dismiss(animated: true, completion: nil)
    }

}

extension AddReminderViewController : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.rowCount(section) ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = viewModel?.getCell(indexPath).identifier
        let viewModel = self.viewModel?.getCell(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier:identifier ?? "" ,for: indexPath) as! CellWithViewModel
        cell.initCell(viewModel)
        
        return cell as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = viewModel?.getCell(indexPath)
        let type = AddReminderViewModel.CellType(rawValue: cell!.type)
        switch type {
        case .details:
            CellRouter(self).toConfigPage(viewModel: self.viewModel!.detailsModalVM)
        case .selectedGroup:
            CellRouter(self).toSelecGroupPage(viewModel: self.viewModel!.listModalVM)
        default:
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel!.secCount()
    }
    
    
}



