//
//  ViewController.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 23/10/2563 BE.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    let listTable = UITableView(frame: CGRect.init(), style: .insetGrouped)
    let addListButton = UIBarButtonItem()
    let addReminderButton = UIBarButtonItem()
    var bottomBarItem = [UIBarButtonItem]()
    let search = UISearchBar()
    var searchController : UISearchController!
    var viewModel = StartPageVM()
    var test: UILabel = UILabel()
    var resultTableVIew : ResultTableView!
    var storage = Set<AnyCancellable>()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DatabaseManager.db.initDefaultList()
        resultTableVIew = ResultTableView()
        resultTableVIew.tableView.delegate = resultTableVIew
        searchController = UISearchController(searchResultsController: resultTableVIew)
        listTable.delegate = self
        listTable.dataSource = self
        
        searchController.searchBar.delegate = self
        view.backgroundColor = UIColor.white
        self.title = "Lists"
        self.navigationItem.searchController = searchController
        view.addSubview(listTable)
        listTable.translatesAutoresizingMaskIntoConstraints = false
        initListTable()
        initToolbar()
        
    }
    
    
    func initToolbar(){
        addListButton.title = "Add List"
        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        
        addListButton.target = self
        addListButton.action = #selector(showAddListDialouge(sender:))
        
        addReminderButton.title = "Add Reminder"
        addReminderButton.target = self
        addReminderButton.action = #selector(addReminder(sender:))
        
        bottomBarItem.append(addReminderButton)
        bottomBarItem.append(spacer)
        bottomBarItem.append(addListButton)
        self.toolbarItems = bottomBarItem
    }
    
    @objc func showAddListDialouge(sender: UIBarButtonItem){
        let alert = UIAlertController(title: "Enter List Name", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let add = UIAlertAction(title: "Add", style: .default){ [self] (action) in
            
            self.addItem(title: alert.textFields![0].text!)
        }
        alert.addTextField(configurationHandler: nil)
        alert.addAction(cancel)
        alert.addAction(add)
        present(alert, animated: true, completion: nil)
    }
    
    func addItem(title: String) {
        DatabaseManager.db.addList(title: title)
        self.viewModel.list = DatabaseManager.db.getLists().value
        DispatchQueue.main.async {
            self.listTable.beginUpdates()
            self.listTable.insertRows(at: [IndexPath(row: self.viewModel.list!.count - 1 , section: 0)], with: .automatic)
            self.listTable.endUpdates()
        }
    }
    
    func delItem(item: List, indexPath: IndexPath){
        DatabaseManager.db.removeData(item: item)
        self.viewModel.list = DatabaseManager.db.getLists().value
        DispatchQueue.main.async {
            self.listTable.beginUpdates()
            self.listTable.deleteRows(at: [indexPath], with: .automatic) 
            self.listTable.endUpdates()
        }
    }
    
    @objc func addReminder(sender: Any){
        StartPageRouter(self).presentAddReminder()
    }
    
    func initListTable(){
        listTable.register(UITableViewCell.self, forCellReuseIdentifier: "ListCell")
        self.viewModel.list = DatabaseManager.db.getLists().value
        NSLayoutConstraint.activate([
            listTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            listTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            listTable.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            listTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            listTable.centerXAnchor.constraint(equalTo: view.centerXAnchor)

        ])
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTable.dequeueReusableCell(withIdentifier: "ListCell",for: indexPath)
        cell.textLabel?.text = self.viewModel.list![indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = listTable.indexPathForSelectedRow!.row
        let viewModel = ReminderVM(index: index)
        viewModel.title = (self.viewModel.list?[listTable.indexPathForSelectedRow!.row].title)!
        viewModel.list = (self.viewModel.list?[index])!
        viewModel.index = index
        viewModel.initData()
        StartPageRouter(self).toReminder(viewModel)
        listTable.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "delete"){ [self] (action,a,b) in
            delItem(item: DatabaseManager.db.getListFromIndex(indexPath.row),indexPath: indexPath)
            
        }
        if indexPath.row == 0 {
            return UISwipeActionsConfiguration()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

extension ViewController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            updateSearch(text: searchText)
        }
    }
    
}

extension ViewController {
    func updateSearch(text: String) {
        let text = text.lowercased()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0, execute: {
            self.resultTableVIew.result = DatabaseManager.db.allReminder().filter({$0.title!.lowercased().contains(text)})
            self.resultTableVIew.tableView.reloadData()
        })
    }
}
