//
//  ReminderViewController.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 23/10/2563 BE.
//

import UIKit

class ReminderViewController: UIViewController{
    
    
    var pageTitle : String = ""
    var items : [Reminders] = []
    let reminderTable : UITableView = UITableView()
    let addButton : UIBarButtonItem = UIBarButtonItem()
    var bottombarItems = [UIBarButtonItem]()
    var viewModel: ReminderVM
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.viewModel.title
        view.backgroundColor = UIColor.white
        view.addSubview(reminderTable)
        navigationItem.rightBarButtonItem = editButton()
        NotificationManager.noti.center.delegate = self
        reminderTable.delegate = self
        reminderTable.dataSource = self
        reminderTable.separatorStyle = .none
        reminderTable.keyboardDismissMode = .interactive
        initTable()
        initToolbar()
        reminderTable.rowHeight = UITableView.automaticDimension
        reminderTable.estimatedRowHeight = 100
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reminderTable.reloadData()
    }
    
    init(viewModel: ReminderVM = ReminderVM()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.initData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initTable(){
        reminderTable.translatesAutoresizingMaskIntoConstraints = false
        reminderTable.register(ReminderCell.self, forCellReuseIdentifier: "ReminderCell")
        NSLayoutConstraint.activate([
            reminderTable.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            reminderTable.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            reminderTable.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            reminderTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    
    
    func initToolbar(){
        addButton.title = "Add Reminder"
        addButton.target = self
        addButton.action = #selector(addReminder(sender: ))
        bottombarItems.append(addButton)
        self.toolbarItems = bottombarItems
    }
    
    func editButton() -> UIBarButtonItem {
        let button = UIButton()
        let barButton = UIBarButtonItem()
        let image = UIImage(systemName: "ellipsis.circle")
        button.setImage(image, for: .normal)
        button.menu = menu()
        barButton.customView = button
        button.showsMenuAsPrimaryAction = true
        return barButton
    }
    
    func menu() -> UIMenu {
        let showHidden = UIAction(title: "Show uncomplete", image: UIImage(systemName: "eye")){_ in
            self.viewModel.state = .all
            self.viewModel.initData()
            self.reminderTable.reloadData()
            self.navigationItem.rightBarButtonItem = self.editButton()
        }
        let hideHidden = UIAction(title: "Hide uncomplete", image:UIImage(systemName: "eye.slash")) {_ in
            self.viewModel.state = .uncomplete
            self.viewModel.initData()
            self.reminderTable.reloadData()
            self.navigationItem.rightBarButtonItem = self.editButton()
        }
        switch viewModel.state {
        case .all :
            return UIMenu(title:"",options: .displayInline,children: [hideHidden])
        case.uncomplete :
            return UIMenu(title:"",options: .displayInline,children: [showHidden])
        
        }
        
    }
    
    @objc func showEditMenu() {
        
    }
    
    @objc func addReminder(sender: Any){
        ReminderRouter(self).presentAddReminder(index: self.viewModel.index ,onAddPressed: {
            self.viewModel.initData()
            self.reminderTable.reloadData()
            
        },onCancelPressed: {})
    }

}

extension ReminderViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ReminderCell
        cell.title.becomeFirstResponder()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reminderTable.dequeueReusableCell(withIdentifier: "ReminderCell") as! ReminderCell
        cell.onDone = {
            self.viewModel.initData()
            self.reminderTable.reloadData()
        }
        cell.index = viewModel.index
        cell.context = self
        cell.initView(reminderData: viewModel.items[indexPath.row])
        cell.check()
        cell.onComplete = {
            let index = self.reminderTable.indexPath(for: cell)
            self.onComplete(index: index)
        }
        return cell
    }
    
    func indexof(item: Reminders) -> Int{
        var uncomplete = [Reminders]()
        var complete = [Reminders]()
        var all = [Reminders]()
        uncomplete = viewModel.list?.contain?.array.filter({!($0 as! Reminders).complete}) as! [Reminders]
        complete = viewModel.list?.contain?.array.filter({($0 as! Reminders).complete}) as! [Reminders]
        all = uncomplete + complete
        return all.firstIndex(of: item)!
    }
    
    func onComplete(index: IndexPath?) {
        switch self.viewModel.state {
        case .all:
            let item = self.viewModel.items[index!.row]
            self.viewModel.items.remove(at: index!.row)
            self.reminderTable.deleteRows(at: [index!], with: .automatic)
            let index = self.indexof(item: item)
            self.viewModel.items.insert(item, at: index)
            self.reminderTable.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        case .uncomplete:
            self.viewModel.items.remove(at: index!.row)
            self.reminderTable.deleteRows(at: [index!], with: .automatic)
        }
        self.viewModel.initData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "delete", handler: {_,_,_ in
            let list = self.viewModel.list?.contain?.array as! [Reminders]
            let item = list[indexPath.row]
            DatabaseManager.db.removeData(item: item)
            self.viewModel.initData()
            self.reminderTable.deleteRows(at: [indexPath], with: .automatic)
            
        })
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
    
}

extension ReminderViewController :  UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let id = UUID(uuidString: userInfo["ID"] as! String)!
        DatabaseManager.db.complete(id: id)
        let index = viewModel.items.firstIndex(where: {$0.id==id})
        onComplete(index: IndexPath(row: index!, section: 0))
        self.reminderTable.reloadData()
        completionHandler()
    }
}
