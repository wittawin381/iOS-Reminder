//
//  ResultTableView.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 7/1/2564 BE.
//

import Foundation
import UIKit


class ResultTableView : UITableViewController {
    var result = [Reminders]()
    override func viewDidLoad() {
        self.tableView.register(ReminderCell.self, forCellReuseIdentifier: "ReminderCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderCell
        cell.onDone = {self.tableView.reloadData()}
        cell.context = self
        cell.initView(reminderData: result[indexPath.row])
        cell.check()
        return cell
    }
}
