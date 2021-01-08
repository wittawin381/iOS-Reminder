//
//  ListModalViewController.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 31/10/2563 BE.
//

import Foundation
import UIKit

class ListModalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var itemList: [List] = [List]()
    var viewModel: ListModalVM?
    let listTable : UITableView = UITableView()
//    var addReminderVM : AddReminderViewModel!
    
    override
    func viewDidLoad() {
        
        view.addSubview(listTable)
        initTable()
    }
    
    init(viewModel: ListModalVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.count() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTable.dequeueReusableCell(withIdentifier: "ListCell",for: indexPath)
        cell.textLabel?.text = self.viewModel?.getItem(indexPath).title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.setIndex(indexPath)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func initTable() {
        listTable.delegate = self
        listTable.dataSource = self
        listTable.register(UITableViewCell.self, forCellReuseIdentifier: "ListCell")
        listTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listTable.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 0),
            listTable.rightAnchor.constraint(equalTo: view.rightAnchor,constant: 0),
            listTable.topAnchor.constraint(equalTo: view.topAnchor,constant: 0),
            listTable.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 0),
        ]);
    }
    
    
}
