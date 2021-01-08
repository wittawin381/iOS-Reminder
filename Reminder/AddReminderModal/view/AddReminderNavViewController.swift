//
//  AddReminderViewController.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 23/10/2563 BE.
//

import UIKit

class AddReminderNavViewController: UINavigationController {
    
    var addReminderViewController = AddReminderViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.viewControllers = [addReminderViewController]
        
    }
}
